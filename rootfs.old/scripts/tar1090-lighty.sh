#!/bin/bash

# Error Log to stdout
sed -i -e 's#/var/log/lighttpd/error.log#/dev/stdout#' /etc/lighttpd/lighttpd.conf

# conf.d (old) to conf-avaible (new)
if [ -d /etc/lighttpd/conf.d/ ] && ! [ -d /etc/lighttpd/conf-enabled/ ] && ! [ -d /etc/lighttpd/conf-available ] && command -v lighttpd &>/dev/null
then
    ln -s /etc/lighttpd/conf.d /etc/lighttpd/conf-enabled
    mkdir -p /etc/lighttpd/conf-available
fi
# mod_alias
if ! grep -qs -E -e '^[^#]*"mod_alias"' /etc/lighttpd/lighttpd.conf /etc/lighttp/conf-enabled/* /etc/lighttpd/external.conf; then
    echo 'server.modules += ( "mod_alias" )' > /etc/lighttpd/conf-available/07-mod_alias.conf
    ln -s -f /etc/lighttpd/conf-available/07-mod_alias.conf /etc/lighttpd/conf-enabled/07-mod_alias.conf
else
    rm -f /etc/lighttpd/conf-enabled/07-mod_alias.conf
fi
# mod_setenv & stat-cache-engine
rm -f /etc/lighttpd/conf-available/87-mod_setenv.conf /etc/lighttpd/conf-enabled/87-mod_setenv.conf
while read -r FILE; do
    sed -i -e 's/^server.modules.*mod_setenv.*/#\0/'  "$FILE"
    sed -i -e 's/^server.stat-cache-engine.*disable.*/#\0/'  "$FILE"
done < <(find /etc/lighttpd/conf-available/* | grep -v setenv)
# add mod_setenv to lighttpd modules, check if it's one too much
echo 'server.modules += ( "mod_setenv" )' > /etc/lighttpd/conf-available/07-mod_setenv.conf
echo 'server.stat-cache-engine = "disable"' > /etc/lighttpd/conf-available/47-stat-cache.conf

ln -s -f /etc/lighttpd/conf-available/07-mod_setenv.conf /etc/lighttpd/conf-enabled/07-mod_setenv.conf
ln -s -f /etc/lighttpd/conf-available/47-stat-cache.conf /etc/lighttpd/conf-enabled/47-stat-cache.conf

if (( $(cat /etc/lighttpd/conf-enabled/* | grep -c -E -e '^server.stat-cache-engine *\= *"disable")') > 1 )); then
    rm -f /etc/lighttpd/conf-enabled/47-stat-cache.conf
fi

if (( $(cat /etc/lighttpd/conf-enabled/* | grep -c -E -e '^server.modules.?\+=.?\(.?"mod_setenv".?\)') > 1 )); then
    rm -f /etc/lighttpd/conf-available/07-mod_setenv.conf /etc/lighttpd/conf-enabled/07-mod_setenv.conf
fi

if lighttpd -tt -f /etc/lighttpd/lighttpd.conf 2>&1 | grep mod_setenv >/dev/null; then
    rm -f /etc/lighttpd/conf-available/07-mod_setenv.conf /etc/lighttpd/conf-enabled/07-mod_setenv.conf
fi

if lighttpd -tt -f /etc/lighttpd/lighttpd.conf 2>&1 | grep stat-cache >/dev/null; then
    rm -f /etc/lighttpd/conf-enabled/47-stat-cache.conf
fi

#lighttpd -tt -f /etc/lighttpd/lighttpd.conf && echo success || true
if lighttpd -tt -f /etc/lighttpd/lighttpd.conf 2>&1 | grep mod_setenv >/dev/null
then
    rm -f /etc/lighttpd/conf-available/07-mod_setenv.conf /etc/lighttpd/conf-enabled/07-mod_setenv.conf
fi

if grep -qs -e '^compress.cache-dir' /etc/lighttpd/lighttpd.conf; then
    echo -----
    echo "Disabling compress.cache-dir in /etc/lighttpd/lighttpd.conf due to often causing full disk issues as there is no automatic cleanup mechanism. Add a leading space to the compress.cache-dir line if you don't want tar1090 to mess with it in the future."
    echo -----
    sed -i -e 's$^compress.cache-dir.*$#\0 # disabled by tar1090, often causes full disk due to not having a cleanup mechanism$' /etc/lighttpd/lighttpd.conf
elif ! grep -qs -e 'disabled by tar1090' /etc/lighttpd/lighttpd.conf; then
    sed -i -e 's$^compress.cache-dir.*$# CAUTION, enabling cache-dir and filetype json will cause full disk when using tar1090\n\0$' /etc/lighttpd/lighttpd.conf
fi

if grep -qs -e '^deflate.cache-dir' /etc/lighttpd/lighttpd.conf; then
    echo -----
    echo "Disabling deflate.cache-dir in /etc/lighttpd/lighttpd.conf due to often causing full disk issues as there is no automatic cleanup mechanism. Add a leading space to the deflate.cache-dir line if you don't want tar1090 to mess with it in the future."
    echo -----
    sed -i -e 's$^deflate.cache-dir.*$#\0 # disabled by tar1090, often causes full disk due to not having a cleanup mechanism$' /etc/lighttpd/lighttpd.conf
elif ! grep -qs -e 'disabled by tar1090' /etc/lighttpd/lighttpd.conf; then
    sed -i -e 's$^deflate.cache-dir.*$# CAUTION, enabling cache-dir and filetype json will cause full disk when using tar1090\n\0$' /etc/lighttpd/lighttpd.conf
fi
