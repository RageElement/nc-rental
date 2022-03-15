# nc-rentals (faizys patch)
Extremely advanced car rental system for mf-inventory. Built for esx-legacy.

# Showcase
* Showcase - https://streamable.com/msejyp (outdated)

# Installation

* Download the script and put it in the [resource] folder.
* Start all the resources in the correct order!
* Paste the following into ms-peds's config (Config.PedList).
    ```lua
	    {
	    	model = `A_M_Y_Business_02`,
	    	coords = vector4(109.0720, -1089.7605, 28.3033, 348.1383), -- Rental - Legion
	    	gender = 'male',
            animDict = 'missheistdockssetup1clipboard@base',
            animName = 'base'
	    },
	    {
	    	model = `A_M_Y_Business_02`,
	    	coords = vector4(-832.3906, -2348.7542, 13.5706, 278.2155), -- Rental - Legion
	    	gender = 'male',
            animDict = 'missheistdockssetup1clipboard@base',
            animName = 'base'
	    },
    ```
* Run the following SQL file:
    ```sql
        INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`, `degrademodifier`, `unique`, `description`) VALUES ('rentalpapers', 'Rental Papers', 0, 0, 1, 0, 1, 'Rental Papers with keys.');
    ```

# Dependencies
* [nh-context](https://github.com/nerohiro/nh-context)
* [ms-peds](https://github.com/MiddleSkillz/ms-peds)
* [qtarget](https://github.com/overextended/qtarget)
* [mf-inventory](https://modit.store/products/mf-inventory)
* [esx-legacy](https://github.com/esx-framework/esx-legacy)
