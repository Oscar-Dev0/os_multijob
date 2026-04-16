Bridge = {}

local fw

if GetResourceState('qbx_core') == 'started' then
    fw = 'qbx'
elseif GetResourceState('qb-core') == 'started' then
    fw = 'qb'
elseif GetResourceState('es_extended') == 'started' then
    fw = 'esx'
end

if not fw then
    error('[multijob] No se detectó framework compatible (qbx_core, qb-core, es_extended)')
end

Bridge.framework = fw
if Config.Debug then
    lib.print.info(('[multijob] Framework detectado: %s'):format(fw))
end
