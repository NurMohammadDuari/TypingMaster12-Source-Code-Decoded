#!/bin/sh
set -e

# integration commands from components/ca-certificates.bst
update-ca-trust extract -o /etc/pki/ca-trust/extracted
chmod -R u+w /etc/pki/ca-trust/extracted

# integration commands from components/glib.bst
glib-compile-schemas /usr/share/glib-2.0/schemas

if [ -d "/usr/lib/x86_64-linux-gnu/gio/modules" ]; then
  gio-querymodules "/usr/lib/x86_64-linux-gnu/gio/modules"
fi

# integration commands from components/fontconfig.bst
if [ -d "/usr/share/fonts" ]; then
  touch -d @0 "/usr/share/fonts" /usr/share/fonts/*
  fc-cache -rs
fi

# integration commands from components/compat-vulkan-link.bst
mkdir -p "/usr/share/vulkan"
ln -svf "/usr/lib/x86_64-linux-gnu/GL/vulkan/icd.d" "/usr/share/vulkan/icd.d"
ln -svf "/usr/lib/x86_64-linux-gnu/GL/vulkan/implicit_layer.d" "/usr/share/vulkan/implicit_layer.d"
ln -svf "/usr/lib/x86_64-linux-gnu/GL/vulkan/explicit_layer.d" "/usr/share/vulkan/explicit_layer.d"

# integration commands from components/cracklib.bst
rm -f "/usr/share/cracklib/pw_dict"{,.pwd,.pwi}
"/usr/bin/create-cracklib-dict" -o "/usr/share/cracklib/pw_dict" "/usr/share/cracklib/cracklib-small"

# integration commands from components/shared-mime-info.bst
PKGSYSTEM_ENABLE_FSYNC=0 update-mime-database "/usr/share/mime"

# integration commands from components/gtk3.bst
gtk-query-immodules-3.0 --update-cache

gtk-update-icon-cache /usr/share/icons/hicolor

# integration commands from components/fdsdk-lic-dedup.bst
fdsdk-lic-dedup

