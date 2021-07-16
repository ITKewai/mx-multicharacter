# Multicharacter

Yo, i'm moxha. I wanted to share the multicharacter system that I have been developing for a while enjoy

# Image:
<img border="0" src="https://i.ibb.co/ns32sPR/Screenshot-1.png" />

# VIDEO: 
https://youtu.be/V87r0_HAujE

## Features
- Citizenid system.
- You can see your character.
- Slots can be unlocked vip players or everyone.
- Cinematic intro

## Requirements
- mx-spawn (https://github.com/MOXHAFOREVA/mx-spawn)

# How To Install

- Open your `server.cfg` and add `ensure mx-multicharacter` `ensure mx-spawn`

| SCRIPT | CHANGE |
| ------ | ------ |
| esx_identity | Remove |
| es_extended | https://github.com/MOXHAFOREVA/es_extended/commit/6632578be693e6ef59cd346ad0e2dd19e352bc50 |
| esx_skin | https://github.com/MOXHAFOREVA/esx_skin/commit/08839900e382ff9942e9899e9a0efa161aaf1e7d |
| skinchanger | https://github.com/MOXHAFOREVA/skinchanger/commit/fcb8b019c671f7e26395ae494b24d199a57d78a6 |

# MySQL 
Open `mysql.sql`

Remove the key of the identifier column from the users table.
Add key from users table to citizenid column.

<img border="0" src="https://i.ibb.co/VvfwmHB/2Bfma.png" />

<img border="0" src="https://i.ibb.co/dfQScnq/image.png"/>



