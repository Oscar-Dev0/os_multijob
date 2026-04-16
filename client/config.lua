local resName = GetCurrentResourceName()
local phone = Config.Phone

MJClient = {
    APP_ID         = phone.appId or resName,
    PHONE_RESOURCE = phone.resource or 'lb-phone',
    APP_NAME       = phone.name or 'MultiJob',
    APP_DESC       = phone.description or 'Aplicación de empleos múltiples',
    APP_DEVELOPER  = phone.developer or 'OscarDev',
    APP_DEFAULT    = phone.defaultApp ~= false,
    APP_UI         = phone.ui or (resName .. '/ui/index.html'),
    APP_ICON       = phone.icon or ('nui://' .. resName .. '/ui/assets/icon.png'),
}
