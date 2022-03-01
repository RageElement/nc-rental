# Video of the script:

* click - https://streamable.com/msejyp
* If you have any further questions, you can add me to Discord. [Found in my github profile]

# Installation

* Download the script and put it in the [resource] folder.
* Download nh-context and put it in the [resource] or [standalone] folder. (it doesn't really matter)
Start all the resources in the correct order!

# Dependencies
* [nh-context](https://github.com/nighmares/nh-context)
* [mythic-notify](https://github.com/JayMontana36/mythic_notify)
* [qtarget](https://github.com/overextended/qtarget)
* [ox_inventory](https://github.com/overextended/ox_inventory)
* Esx legacy

# Adding the RentalPapers to ox_inventory

* Go to ox_inventory/data/items.lua

```lua

    ['rentalpapers'] = {
        label = 'Rental papers',
        weight = 30,
        close = true,
	stack = true,
	consume = 0,
	server = {	
	}
    },

```
