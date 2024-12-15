# Bus Driver Job
ESX Job for being a bus driver. Drive around picking up passengers, earning money for your routes. An excellent job for less populated role playing servers.

All the routes and stops are defined in a database.

This script was written from scratch as practice for the up coming delivery driver job I wish to write.


[Demo Video](https://i.lu.je/2021/KB42yjJCZf.mp4)

# Installation
## Requirements
- FiveM
- ESX Legacy (es_extended)
- esx_addonaccount
- esx_skin
- [oxmysql](https://github.com/overextended/oxmysql)

## Via Git ( recommended )
From your resouces directory for the ESX server:
```
git clone https://github.com/Lachee/fivem-busdriver.git "fivem-busdriver"
```

Then in you server cfg:
- `ensure fivem-busdriver`

**Ensure you migrate your database with the `sql/*.sql` scripts.**


# TODO
Add timeout to bus embarkment so it doesnt get stuck
