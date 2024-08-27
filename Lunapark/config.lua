Config = {}


-- Lokacija gdje će se pojaviti automobil
Config.VehicleSpawnLocation = { 
    x = -1732.36,
    y = -1133.02,
    z = 14.00,
    heading = 160.0  -- Smjer u kojem će se automobil okrenuti
}

-- Postavke automobila
Config.Vehicle = {
    model = 'veto2',      -- Model automobila
    plate = 'GoKart',      -- Registarska tablica
    price = 100           -- Cijena za korištenje automobila
}

-- Lokacija ped-a koji iznajmljuje vozilo
Config.RentalPed = {
    model = 'a_f_y_beach_01',  -- Ped model, promijenite ako želite drugačiji ped
    location = {x = -1728.28, y = -1112.90, z = 13.83, heading = 143.82} -- Lokacija ped-a
}
