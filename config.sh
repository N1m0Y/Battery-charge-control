##########################################################################################
#
# Magisk
# by topjohnwu
#
# SYSTEM/LESS Installation
# by veez21
# 
# This is a template zip for developers
#
##########################################################################################
##########################################################################################
# 
# Instructions:
# 
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure the settings in this file (common/config.sh)
# 4. For advanced features, add shell commands into the script files under common:
#    post-fs-data.sh, service.sh
# 5. For changing props, add your additional/modified props into common/system.prop
# 
##########################################################################################

##########################################################################################
# Defines
##########################################################################################

# NOTE: This part has to be adjusted to fit your own needs

# This will be the folder name under /magisk
# This should also be the same as the id in your module.prop to prevent confusion
MODID=battery-charge-control

# Set to true if you need to enable Magic Mount
# Most mods would like it to be enabled
# ** When system install is used, this will also be used 
#    as a flag is if system modding will be done.
AUTOMOUNT=true

# Set to true if you need to load system.prop
# ** When system install is used, the props in
#    system.prop will be put directly to /system/build.prop
PROPFILE=false

# Set to true if you need post-fs-data script
# ** When system install is used, the scripts will
#    go to /su/su.d, /system/su.d (if SuperSU is installed
#    or /system/etc/init.d
POSTFSDATA=false

# Set to true if you need late_start service script
# ** When system install is used, the scripts will
#    go to /su/su.d, /system/su.d (if SuperSU is installed
#    or /system/etc/init.d
LATESTARTSERVICE=false

##########################################################################################
# Installation Message
##########################################################################################

# Set what you want to show when installing your mod

print_modname() {
  ui_print "******************************"
  ui_print "    Battery Charge Control    "
  ui_print "******************************"
}

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# By default Magisk will merge your files with the original system
# Directories listed here however, will be directly mounted to the correspond directory in the system
# ** When system install is used, the directories listed will be renamed to 'previous-foldername.bak'.
#    Example: /system/app/Youtube -> /system/app/Youtube.bak
#    If PERMANENTDELETE variable is set to true, it will permanently delete the folder from /system.

# You don't need to remove the example below, these values will be overwritten by your own list
# This is an example
REPLACE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here, it will overwrite the example
# !DO NOT! remove this if you don't need to replace anything, leave it empty as it is now
REPLACE="
"

##########################################################################################
# Install Configuration
##########################################################################################

# You can tweak your installation process by putting Variables in /dev/.config
# Valid Variables:
#   MAGISKINSTALL - forces magisk installation (might conflict with SYSTEMINSTALL) (values: true or false)
#   SYSTEMINSTALL - forces system installation (might conflict with MAGISKINSTALL) (values: true or false)
#   INITPATH - sets path to install scripts (post-fs-data.sh, service.sh) if system install (values: directories)
#   BUILDPROP - sets properties from system.prop directly to build.prop (values: true or false)
#   PERMANENTDELETE - PERMANENTLY delete folders in $REPLACE (values: true or false)
# Editing here directly is also valid, but will be overwritten in /dev/.config
# Leave it blank if you don't need it.
# MAGISKINSTALL is enabled by default to prioritize Magisk.
MAGISKINSTALL=true
SYSTEMINSTALL=
INITPATH=
BUILDPROP=
PERMANENTDELETE=

##########################################################################################
# Permissions
##########################################################################################

# NOTE: This part has to be adjusted to fit your own needs

set_permissions() {
  # Default permissions, don't remove them
  set_perm_recursive  $MODPATH  0  0  0755  0644

  # Only some special files require specific permissions
  # The default permissions should be good enough for most cases

  # Some templates if you have no idea what to do:

  # set_perm_recursive  <dirname>                <owner> <group> <dirpermission> <filepermission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm_recursive  $MODPATH/system/lib       0       0       0755            0644

  # set_perm  <filename>                         <owner> <group> <permission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm  $MODPATH/system/bin/app_process32   0       2000    0755         u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0       2000    0755         u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0       0       0644
  set_perm $MODPATH/system/bin/bcc_magisk 0 0 0755
}

set_permissions_system() {
  # THIS WILL ONLY GET INVOKED WHEN SYSTEM INSTALL IS USED
  # USE THIS TO SET PERMISSIONS TO SYSTEM FILES
  # SEE set_permissions for instructions.

  # Default permissions, don't remove them
  set_perm  /system/build.prop  0  0  0644
  
  # Add commands below
  set_perm /system/bin/bcc_magisk 0 0 0755
}
