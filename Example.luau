--[[
    ============================================================================
    Fluent-Krita — Complete Feature & API Documentation Script
    ============================================================================
    Covers:
      1. Library Initialization & Addons
      2. CreateWindow (All Standard + Krita++ Options)
      3. Tabs & Icons (Lucide, Material, Asset IDs) & Home/Player Tab
      4. Sections & All 8 UI Elements + Every Element Method
      5. Window & Library Runtime Methods (Themes, Backgrounds, Minimize, etc.)
      6. SaveManager & InterfaceManager Integration
    ============================================================================
]]

--------------------------------------------------------------------------------
-- 1. LOAD LIBRARY & ADDONS
--------------------------------------------------------------------------------
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Dominkroptru123/Fluent-Krita/refs/heads/main/FluentKrita.luau"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Shortcuts & Library Properties
local Options = Fluent.Options -- Table containing all registered elements by ID
print("Fluent Version:", Fluent.Version)
print("Available Themes:", table.concat(Fluent.Themes, ", "))

--------------------------------------------------------------------------------
-- 2. CREATE WINDOW (ALL AVAILABLE OPTIONS)
--------------------------------------------------------------------------------
local Window = Fluent:CreateWindow({
    -- [Core Appearance]
    Title = "Fluent " .. Fluent.Version,       -- Required: Window title
    SubTitle = "Krita++ Documentation",        -- Optional: Subtitle next to title
    TabWidth = 160,                            -- Sidebar width in pixels
    Size = UDim2.fromOffset(580, 460),         -- Initial window size
    Acrylic = true,                            -- Enables DepthOfField glass blur (detectable in some games)
    Theme = "Dark",                            -- "Dark" | "Darker" | "Light" | "Aqua" | "Amethyst" | "Rose"
    MinimizeKey = Enum.KeyCode.RightShift,     -- Keybind to toggle window visibility

    -- [Custom Window Background]
    -- Accepts: string URL (http/https), "rbxassetid://...", numeric ID, or table:
    -- { Image = "...", Transparency = 0.7, ScaleType = Enum.ScaleType.Crop }
    Background = "https://i.pinimg.com/736x/19/08/bc/1908bc8280fc5a4d331631937ee541c5.jpg",
    BackgroundTransparency = 0.7,              -- 0 (opaque) to 1 (invisible)

    -- [Window Behavior & Animations]
    Resizable = true,                          -- Enables bottom-right resize grip (false hides grip & locks size)
    MinimizeSpeed = 0.25,                      -- Alias: ZoomSpeed / AnimationSpeed (seconds)
    MinimizeButtonSpeed = 0.25,                -- Optional override speed for the TitleBar "-" button

    -- [Startup Loading Screen]
    -- Can be `true`, `false`, or a configuration table:
    LoadingScreen = {
        Enabled = true,
        Title = "Krita++",
        SubTitle = "Loading modules...",
        Duration = 1.5,                        -- Seconds to spin before fading out
        FadeInSpeed = 0.35,                    -- Fade-in duration
        FadeOutSpeed = 0.35,                   -- Fade-out duration
        RotateSpeed = 1.5,                     -- Spinner rotations per second
        Icon = "rbxassetid://10723433935",     -- Optional custom spinner asset ID
    },

    -- [Home / Player Info Tab]
    HomeTab = true,                            -- Creates the built-in Home tab at index 1
    HomeIcon = "home",                         -- Icon name, numeric ID, or "rbxassetid://..."
    HomeIconSource = "Lucide",                 -- "Lucide" or "Material"

    PlayerTab = {
        Enabled = true,                        -- Set false to disable PlayerTab even if HomeTab = true
        Subtitle = "User Info",                -- Alias: Role (shown under username in sidebar & banner)
        UseDisplayName = false,                -- true = DisplayName in sidebar; false = Username
        -- Executor = "CustomName",            -- Optional: override auto-detected executor name
        Discord = "FaWV7Kxvvp",                -- Alias: DiscordInvite / Invite (code or full discord.gg/ link)
    },

    -- [Executor Compatibility Checker (Displayed in HomeTab)]
    SupportedExecutor = {
        FullSupported = {
            "Volt", "Potassium", "Wave", "Synapse Z", "Lucid", "Lynx",
            "Real", "Madium", "Isaeva", "Athena", "SirHurt", "Opiumware",
            "MacSploit", "Delta", "Vega X", "Codex"
        },
        HalfSupported = {
            "Solara", "Xeno", "Velocity", "Fluxus", "Script-Ware", "Krnl"
        },
        Unsupported = {
            "JJSploit", "Celery"
        }
    },

    -- [Mobile-Only Draggable Toggle Icon]
    -- Can be `true` or a table. Only spawns on touch devices without a hardware keyboard.
    MobileIcon = {
        Enabled = true,
        Image = "rbxassetid://93963297214846",
        Size = UDim2.new(0, 75, 0, 75),
        Position = UDim2.new(0, 20, 0.5, -25),
        -- Optional extras:
        -- CornerRadius = UDim.new(0.5, 0),
        -- BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        -- BackgroundTransparency = 0,
    },
})

--------------------------------------------------------------------------------
-- 3. ADDING TABS & USING ICONS
--------------------------------------------------------------------------------
-- Supported Icon formats:
--   • "" or nil              -> No icon
--   • "settings"             -> Resolved via Nebula Icons or bundled Lucide icons
--   • "home" + ImageSource   -> ImageSource = "Lucide" (default) or "Material"
--   • "rbxassetid://123456"  -> Direct Roblox asset ID
--   • 123456 or "123456"     -> Numeric Roblox asset ID

local Tabs = {
    Elements = Window:AddTab({ Title = "Elements", Icon = "layers", ImageSource = "Lucide" }),
    Controls = Window:AddTab({ Title = "Window & API", Icon = "sliders", ImageSource = "Lucide" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

-- You can also append your own custom sections/elements to the Home Tab:
if Window.PlayerTab then
    local customHomeSec = Window.PlayerTab:AddSection("Custom Hub Notes")
    customHomeSec:AddParagraph({
        Title = "Changelog",
        Content = "Added MobileIcon, LoadingScreen, Background URLs, and HomeTab."
    })
end

--------------------------------------------------------------------------------
-- 4. SECTIONS & ALL 8 UI ELEMENTS + METHODS
--------------------------------------------------------------------------------
-- Elements can be added directly to a Tab (Tab:AddToggle(...)) OR inside a Section (Section:AddToggle(...)).
local BasicSection = Tabs.Elements:AddSection("Basic Elements")
local InputSection = Tabs.Elements:AddSection("Selection & Input Elements")

-- [4.1] PARAGRAPH
local MyParagraph = BasicSection:AddParagraph({
    Title = "Paragraph Title",
    Content = "Line 1 of paragraph.\nLine 2 of paragraph."
})
-- Paragraph Methods:
-- MyParagraph:SetTitle("Updated Title")
-- MyParagraph:SetDesc("Updated Content")
-- MyParagraph:Destroy()

-- [4.2] BUTTON + DIALOG
local MyButton = BasicSection:AddButton({
    Title = "Open Confirmation Dialog",
    Description = "Triggers Window:Dialog with multiple buttons.",
    Callback = function()
        Window:Dialog({
            Title = "Dialog Title",
            Content = "Are you sure you want to run this action?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        Fluent:Notify({
                            Title = "Dialog",
                            Content = "Confirmed!",
                            Duration = 3
                        })
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled dialog.")
                    end
                }
            }
        })
    end
})
-- Button Methods:
-- MyButton:SetTitle("New Button Title")
-- MyButton:SetDesc("New Button Description")
-- MyButton:Destroy()

-- [4.3] TOGGLE
local MyToggle = BasicSection:AddToggle("MyToggle", {
    Title = "Enable Feature",
    Description = "Boolean switch stored at Options.MyToggle.",
    Default = false,
    Callback = function(Value)
        print("[Toggle Callback] Value:", Value)
    end
})
MyToggle:OnChanged(function(Value)
    print("[Toggle OnChanged] Value:", Value, "| Options.MyToggle.Value:", Options.MyToggle.Value)
end)
-- Toggle Methods:
-- Options.MyToggle:SetValue(true)
-- MyToggle:SetTitle("...")
-- MyToggle:SetDesc("...")
-- MyToggle:Destroy()

-- [4.4] SLIDER
local MySlider = BasicSection:AddSlider("MySlider", {
    Title = "WalkSpeed Multiplier",
    Description = "Supports decimal rounding (Rounding = 1 -> 0.1 steps).",
    Default = 2,
    Min = 0,
    Max = 10,
    Rounding = 1, -- 0 = integers only, 1 = 1 decimal place, 2 = 2 decimal places
    Callback = function(Value)
        print("[Slider Callback] Value:", Value)
    end
})
MySlider:OnChanged(function(Value)
    print("[Slider OnChanged] Value:", Value)
end)
-- Slider Methods:
-- MySlider:SetValue(3.5)
-- MySlider:SetTitle("...")
-- MySlider:SetDesc("...")
-- MySlider:Destroy()

-- [4.5] SINGLE DROPDOWN
local SingleDropdown = InputSection:AddDropdown("SingleDropdown", {
    Title = "Single Dropdown",
    Description = "Choose one item.",
    Values = { "One", "Two", "Three", "Four", "Five" },
    Multi = false,
    Default = 1,          -- Can be index (1) or string ("One")
    AllowNull = false,    -- Allow deselecting so nothing is selected
    Callback = function(Value)
        print("[SingleDropdown Callback] Selected:", Value)
    end
})
SingleDropdown:SetValue("Four")
SingleDropdown:OnChanged(function(Value)
    print("[SingleDropdown OnChanged] Selected:", Value)
end)

-- [4.6] MULTI DROPDOWN
local MultiDropdown = InputSection:AddDropdown("MultiDropdown", {
    Title = "Multi Dropdown",
    Description = "Choose multiple items.",
    Values = { "Apple", "Banana", "Cherry", "Date", "Elderberry" },
    Multi = true,
    Default = { "Apple", "Cherry" }, -- Array of strings for initial defaults
    Callback = function(ValueTable)
        -- ValueTable is a dictionary: { Apple = true, Cherry = true }
    end
})
-- SetValue on MultiDropdown expects a dictionary of [option] = true/false:
MultiDropdown:SetValue({
    Apple = true,
    Banana = true,
    Cherry = false
})
MultiDropdown:OnChanged(function(ValueTable)
    local selected = {}
    for k, enabled in next, ValueTable do
        if enabled then
            table.insert(selected, k)
        end
    end
    print("[MultiDropdown OnChanged] Selected:", table.concat(selected, ", "))
end)
-- Dropdown Methods (Single & Multi):
-- SingleDropdown:SetValues({ "NewA", "NewB", "NewC" }) -- Replaces list dynamically
-- SingleDropdown:Open() / SingleDropdown:Close()
-- SingleDropdown:Destroy()

-- [4.7] COLORPICKER (Standard & With Transparency)
local MyColorpicker = InputSection:AddColorpicker("MyColorpicker", {
    Title = "Accent Color",
    Description = "RGB/HSV color picker.",
    Default = Color3.fromRGB(96, 205, 255),
    Callback = function(Color)
        print("[Colorpicker] RGB:", Color)
    end
})
MyColorpicker:OnChanged(function(Color)
    print("[Colorpicker OnChanged] Hex:", Color:ToHex())
end)
MyColorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))
-- Also supports HSV table: MyColorpicker:SetValue({ 0.5, 1, 1 })

local AlphaColorpicker = InputSection:AddColorpicker("AlphaColorpicker", {
    Title = "Transparent Color",
    Description = "Includes an Alpha/Transparency slider.",
    Transparency = 0.25, -- Enables alpha slider when provided
    Default = Color3.fromRGB(96, 205, 255),
    Callback = function(Color)
        print("[AlphaColorpicker] Color:", Color, "Transparency:", Options.AlphaColorpicker.Transparency)
    end
})
-- SetValueRGB with transparency: AlphaColorpicker:SetValueRGB(Color3.fromRGB(255, 80, 80), 0.5)

-- [4.8] KEYBIND
local MyKeybind = InputSection:AddKeybind("MyKeybind", {
    Title = "Action Keybind",
    Description = "Supports Keyboard, MouseLeft (MB1), MouseRight (MB2).",
    Mode = "Toggle",         -- "Toggle" | "Hold" | "Always"
    Default = "LeftControl", -- Enum.KeyCode.Name, "MouseLeft", "MouseRight", or "None"
    Callback = function(IsToggled)
        print("[Keybind Callback] Toggled:", IsToggled)
    end,
    ChangedCallback = function(NewKey)
        print("[Keybind ChangedCallback] New key:", NewKey)
    end
})
MyKeybind:OnClick(function(State)
    print("[Keybind OnClick] State:", State)
end)
MyKeybind:OnChanged(function(KeyName)
    print("[Keybind OnChanged] Bound to:", KeyName)
end)
-- Check live state in a loop (essential for "Hold" and "Always" modes):
task.spawn(function()
    while not Fluent.Unloaded do
        if MyKeybind:GetState() then
            -- Active while held / toggled / always
        end
        task.wait(0.25)
    end
end)
-- Keybind Methods:
-- MyKeybind:SetValue("F", "Hold") -- Changes key & mode
-- MyKeybind:SetValue("MouseRight", "Toggle")

-- [4.9] INPUT (TEXTBOX)
local MyInput = InputSection:AddInput("MyInput", {
    Title = "Custom Input",
    Description = "Supports numeric filtering, max length, and FocusLost-only triggers.",
    Default = "Hello",
    Placeholder = "Type here...",
    Numeric = false,   -- true = numbers only
    Finished = false,  -- true = fires only on Enter/FocusLost; false = fires every keystroke
    MaxLength = 32,    -- Optional character limit
    Callback = function(Text)
        print("[Input Callback] Text:", Text)
    end
})
MyInput:OnChanged(function(Text)
    print("[Input OnChanged] Text:", Text)
end)
-- Input Methods:
-- MyInput:SetValue("Updated text")
-- MyInput:SetTitle("...")
-- MyInput:SetDesc("...")
-- MyInput:Destroy()

--------------------------------------------------------------------------------
-- 5. WINDOW & LIBRARY RUNTIME CONTROLS (ALL METHODS DEMO)
--------------------------------------------------------------------------------
local WindowSec = Tabs.Controls:AddSection("Window & Theme Controls")
local UtilitySec = Tabs.Controls:AddSection("Library Utilities")

WindowSec:AddDropdown("ThemeSwitcher", {
    Title = "Quick Theme Switch",
    Values = Fluent.Themes,
    Default = Fluent.Theme,
    Callback = function(ThemeName)
        Fluent:SetTheme(ThemeName)
    end
})

WindowSec:AddToggle("AcrylicToggle", {
    Title = "Toggle Acrylic Blur",
    Default = Fluent.UseAcrylic,
    Callback = function(State)
        Fluent:ToggleAcrylic(State)
    end
})

WindowSec:AddToggle("TransparencyToggle", {
    Title = "Toggle Window Transparency",
    Default = true,
    Callback = function(State)
        Fluent:ToggleTransparency(State)
    end
})

WindowSec:AddToggle("ResizableToggle", {
    Title = "Allow Window Resizing",
    Default = true,
    Callback = function(State)
        Window:SetResizable(State)
    end
})

WindowSec:AddSlider("BgTransparencySlider", {
    Title = "Background Image Transparency",
    Default = 0.7,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        Window:SetBackgroundTransparency(Value)
    end
})

WindowSec:AddInput("BgImageInput", {
    Title = "Change Background Image",
    Placeholder = "Asset ID or https://... URL",
    Finished = true,
    Callback = function(Source)
        -- Pass "" to clear the background image
        Window:SetBackground(Source, Options.BgTransparencySlider.Value, Enum.ScaleType.Crop)
    end
})

WindowSec:AddButton({
    Title = "Toggle Maximize (Dot Syntax)",
    Description = "Calls Window.Maximize(not Window.Maximized).",
    Callback = function()
        Window.Maximize(not Window.Maximized)
    end
})

WindowSec:AddButton({
    Title = "Minimize Window (0.3s)",
    Description = "Demonstrates Window:Minimize(customSpeed).",
    Callback = function()
        Window:SetMinimizeSpeed(0.3)
        Window:SetMinimizeButtonSpeed(0.3)
        Window:Minimize(0.3)
    end
})

UtilitySec:AddButton({
    Title = "Send Notification",
    Description = "Demonstrates Fluent:Notify.",
    Callback = function()
        Fluent:Notify({
            Title = "Notification Title",
            Content = "Main message content.",
            SubContent = "Optional sub-content line.",
            Duration = 5 -- Set to nil for persistent notification until closed manually
        })
    end
})

UtilitySec:AddButton({
    Title = "Resolve Icon Asset",
    Description = "Calls Fluent:GetIcon('shield', 'Lucide').",
    Callback = function()
        local asset = Fluent:GetIcon("shield", "Lucide")
        Fluent:Notify({
            Title = "Icon Resolver",
            Content = tostring(asset),
            Duration = 4
        })
    end
})

UtilitySec:AddButton({
    Title = "Jump to Home Tab",
    Description = "Calls Window:SelectPlayerTab() (or Window:SelectTab(1)).",
    Callback = function()
        Window:SelectPlayerTab()
    end
})

UtilitySec:AddButton({
    Title = "Unload Interface",
    Description = "Cleanly disconnects signals and destroys the GUI.",
    Callback = function()
        Fluent:Destroy()
    end
})

--------------------------------------------------------------------------------
-- 6. SAVEMANAGER & INTERFACEMANAGER ADDONS
--------------------------------------------------------------------------------
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Prevent SaveManager from overwriting InterfaceManager's theme settings
SaveManager:IgnoreThemeSettings()

-- Exclude specific Option IDs from being saved into config files
SaveManager:SetIgnoreIndexes({ "ThemeSwitcher", "BgImageInput" })

-- Folder structure inside your executor's workspace folder
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

-- Populate the Settings tab with built-in Theme/Acrylic/Keybind & Config UI
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Select initial tab (1 = HomeTab if HomeTab = true, otherwise first AddTab)
Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent-Krita",
    Content = "Documentation script loaded successfully.",
    Duration = 6
})

-- Automatically load any config marked as autoload
SaveManager:LoadAutoloadConfig()
