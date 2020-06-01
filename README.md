# RealisticWeapons
Mod to change modificators in "Mount &amp; Blade II bannerlord"

# Updating to a new game version
As I currently don't play Bannerlord actively, I don't maintain the mod. If you want the mod for a new version, you can update the files quite easily

  1. Fork my project on github.
  2. Go to the folder generator/source_data and update the files crafting_pieces.xml (SandBoxCore/ModuleData/spnpccharacters.xml) and spnpccharacters.xml (Native/ModuleData/crafting_pieces.xml) files from the base game (the rest of the files aren't used at the moment)
  3. Go to the folder generator and execute build_characters.ps1 and build_pieces.ps1. You should copy the generated file before running the second script, as it will get deleted.
  4. Unpack the latest packed build from the folder versions and repalce the modified_* (generated) and orig_* (original files). Optionally you can also add the result_* files, but they are just for informational purposes.
  5. Pack the folder as a new version, and put the ZIP into the versions folder. The new naming should be "RealisticWeapons_[mod-version]_[bannerlord-version].zip", where [version] ist the Bannerlord version (e.g. "e1.3.0"). Add "_beta" after [version], if it's for the beta build.
  6. Make a pull request. The only required files is the ZIP file in the version folder.
  
When a new version gets added via pullrequest, I will update the mod page on nexusmods.com.
  
# Fixing bugs (scripts)
If you find any bugs, feel free to just fix them in a fork. 

Please recompile the files for the current Bannerlord version afterwards and increase the fix version (e.g. 0.2.1 -> 0.2.2).

# Adding features
If you want to add new features or modify new files, feel free to do so. You will have to figure out the scripts on yourself, but they aren't that complex. If I like the changes, I will merge them. Otherwise, feel free to release the forked version yourself.

Please recompile the files for the current Bannerlord version afterwards and increase the minor version (e.g. 0.2.1 -> 0.3.0).
