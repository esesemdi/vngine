# VNScript Language Reference

A scripting language for visual novel development in Godot.

---

## Comments

```
# This is a comment
```

---

## Wait

Pause script execution.

| Syntax | Description |
|--------|-------------|
| `wait <time>` | Wait for duration before next command |
| `wait <command> in <time>` | Wait for the duration specified in a previous command's transition |
| `wait <command> with transition in <time>` | Same as above, for commands with explicit transitions |

**Examples:**
```
wait 2.5
wait .bg in 1.0
wait .move alice with slide in 0.5
```

---

## Settings

Modify engine or story settings.

```
.set <setting> <value>
```

**Available Settings:**

| Setting | Description |
|---------|-------------|
| `text_speed` | Dialogue text display speed |
| `text_size` | Dialogue text size |
| `text_font` | Dialogue font |
| `music_volume` | Music volume level |
| `sfx_volume` | Sound effects volume level |
| `<variable_name>` | Any story variable |

**Examples:**
```
.set text_speed 1.5
.set music_volume 0.8
.set player_karma 10
```

---

## Execute

Run arbitrary GDScript code.

```
.exe "<gdscript_code>"
```

**Example:**
```
.exe "GameManager.unlock_achievement('first_chapter')"
```

---

## Backgrounds

Control background images and videos.

| Syntax | Description |
|--------|-------------|
| `.bg "<name>"` | Set background immediately |
| `.bg "<name>" with <transition> in <time>` | Set with transition |
| `.bg off` | Hide background immediately |
| `.bg off with <transition> in <time>` | Hide with transition |
| `.bg <setting>` | Apply setting immediately |
| `.bg <setting> with <transition> in <time>` | Apply setting with transition |

**Transitions:** `fade`

**Settings:**

| Setting | Values | Description |
|---------|--------|-------------|
| `hue` | `0-360` or `reset` | Adjust hue |
| `brightness` | `0-100` or `reset` | Adjust brightness |
| `speed` | `0.1-3` or `reset` | Playback speed (video only) |

**Examples:**
```
.bg "classroom"
.bg "sunset_beach" with fade in 1.5
.bg hue 180
.bg brightness 50 with fade in 2.0
.bg off with fade in 1.0
```

---

## Video

Play and control video playback.

| Syntax | Description |
|--------|-------------|
| `.video "<name>"` | Play video immediately |
| `.video "<name>" with transition in <time>` | Play with transition |
| `.video pause` | Pause current video |
| `.video unpause` | Resume current video |
| `.video off` | Stop and hide video |

**Examples:**
```
.video "intro_cinematic"
.video "flashback" with fade in 0.5
.video pause
```

---

## Music

Control background music.

| Syntax | Description |
|--------|-------------|
| `.mus "<name>"` | Play music immediately |
| `.mus "<name>" in <time>` | Play with fade in |
| `.mus off` | Stop music immediately |
| `.mus off in <time>` | Stop with fade out |
| `.mus pause` | Pause music |
| `.mus pause in <time>` | Pause with fade |
| `.mus unpause` | Resume music |
| `.mus unpause in <time>` | Resume with fade |
| `.mus <setting>` | Apply setting immediately |
| `.mus <setting> in <time>` | Apply setting with fade |

**Settings:**

| Setting | Values | Description |
|---------|--------|-------------|
| `pitch` | `0.5-1.5` or `reset` | Adjust pitch |
| `reverb` | `0-1` or `reset` | Reverb amount |
| `delay` | `0-1` or `reset` | Delay effect |

**Examples:**
```
.mus "main_theme"
.mus "battle_music" in 2.0
.mus pitch 0.8
.mus off in 3.0
```

---

## Sound Effects

Play sound effects and control the SFX channel.

| Syntax | Description |
|--------|-------------|
| `.sfx "<name>"` | Play sound effect |
| `.sfx <setting>` | Apply setting to SFX channel |

**Settings:**

| Setting | Values | Description |
|---------|--------|-------------|
| `pitch` | `0.5-1.5` or `reset` | Adjust pitch |
| `reverb` | `0-1` or `reset` | Reverb amount |
| `delay` | `0-1` or `reset` | Delay effect |

**Examples:**
```
.sfx "door_slam"
.sfx "footsteps"
.sfx pitch 1.2
```

---

## Stage

Manage character positioning on screen.

### Adding and Removing Characters

| Syntax | Description |
|--------|-------------|
| `.add <char_id>` | Add character to stage |
| `.add <char_id> with <transition> <time>` | Add with transition |
| `.remove <char_id>` | Remove character from stage |
| `.remove <char_id> with <transition> <time>` | Remove with transition |

### Moving Characters

| Syntax | Description |
|--------|-------------|
| `.move <char_id> <position>` | Move to position |
| `.move <char_id> <position> with <transition> <time>` | Move with transition |
| `.nudge <char_id> <direction> by <amount>` | Nudge in direction |
| `.nudge <char_id> <direction> by <amount> with <transition> <time>` | Nudge with transition |

**Transitions:** `slide`, `fade`

**Positions:** `farleft`, `left`, `center`, `right`, `farright`, `origin`

**Directions:** `left`, `right`, `closer`, `away`, `up`, `down`, `flip`

> **Note:** `origin` returns the character to their initial position. `flip` mirrors the character horizontally and does not accept a value.

**Examples:**
```
.add alice
.add bob with fade 0.5
.move alice center
.move bob left with slide 0.3
.nudge alice right by 50
.nudge bob flip
.remove alice with fade 1.0
```

---

## Dialogue

Display character dialogue and narration.

| Syntax | Description |
|--------|-------------|
| `<char_id> "text"` | Character speaks |
| `"text"` | Narrator speaks |
| `"text" <position>` | Display text without UI |

**Positions:** `top`, `center`, `bottom`

**Examples:**
```
alice "Hello, how are you?"
"The room fell silent."
"Chapter 1" center
bob "I wasn't expecting to see you here."
```

---

## Character State

Change character appearance.

| Syntax | Description |
|--------|-------------|
| `<char_id> is <emotion>` | Change character emotion |
| `<char_id> now <state>` | Change character state |

**Examples:**
```
alice is happy
alice is surprised
bob now sitting
bob now injured
```

---

## Flow Control

### Scenes

Define and navigate between scenes.

| Syntax | Description |
|--------|-------------|
| `@scene_name` | Define scene start |
| `@end` | End chapter, proceed to next |
| `.goto @scene_name` | Jump to scene |
| `.goto @end` | End chapter immediately |

**Example:**
```
@intro
alice "Welcome to the game!"
.goto @main_hall

@main_hall
"You enter the main hall."
alice "Where should we go?"

@end
```

### Choices

Present player choices.

```
.choice
"<choice_text>" .goto @scene_name
"<choice_text>" .set <variable> <value> and .goto @scene_name
.choice end
```

**Examples:**
```
.choice
"Go to the garden" .goto @garden
"Stay inside" .goto @stay
"Ask about the key" .set asked_about_key 1 and .goto @ask_key
.choice end
```

### Conditionals

Execute commands based on variable values.

```
.if <variable> is <value>
<commands>
.if end

.if <variable> not <value>
<commands>
.if end
```

> **Note:** Only `is` (equality) and `not` (inequality) comparisons are supported. Compound conditions and else-if chains are not supported. Use multiple `.if` blocks if needed.

**Examples:**
```
.if player_karma is 10
alice is happy
alice "You're a good person!"
.if end

.if has_key not 0
"You unlock the door."
.goto @secret_room
.if end
```

---

## Complete Example

```
@start
.bg "mansion_exterior" with fade in 1.0
.mus "mystery_theme" in 2.0

"The old mansion loomed before you."

.add alice with fade 0.5
.move alice center with slide 0.3

alice is nervous
alice "Are you sure about this?"

.sfx "thunder"
.bg brightness 30 with fade in 0.2
wait 0.5
.bg brightness reset with fade in 0.3

.choice
"Let's go inside" .goto @enter
"Maybe we should leave" .set courage 0 and .goto @leave
.choice end

@enter
.set courage 1
alice is determined
alice "Alright, let's do this."
.bg "mansion_foyer" with fade in 1.0
.goto @foyer

@leave
alice "I think you're right..."
.remove alice with fade 1.0
.bg off with fade in 2.0
.goto @end

@foyer
.if courage is 1
"You feel brave as you step inside."
.if end
alice "It's dark in here..."

@end
```
