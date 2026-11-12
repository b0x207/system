{ inputs, ... }: {
  /**
    Provides a generator for QT's `.colors` files which are essential a specialized INI file.
    The value that this generator provides over `lib.generators.toINI` is a set of ergonomic
    improvements that cut down on the amount of redundant work.

    Note that most of the "improvements" are based on some assumptions that the color file will be
    similar to KDE's Breeze Dark theme.

    # Type

    ```
    toQTColors :: {String::Any} -> {String::Any} -> {String::{String::Any}}
    ```

    # Arguments

    - [overrides] An attribute set of any manual overrides for a given color section (e.g.
      `Colors:Window`). Note that any given override must be fully specified as it loses most of
      the benefits provided by this generator.
    - [spec] The color scheme specification which must specify palette value combos. These combos
      are not documented here so you will have to read the source for this function.
  */
  flake.lib.generators.toQTColors =
    overrides: spec:
    let
      lib = inputs.nixpkgs.lib;
      generator = lib.generators.toINI {
        # The section name formatting must be used since the INI generator always surrounds the
        # section name with square brackets. To fix this, drop the first and last characters which
        # should always be a pair of matching square brackets on valid inputs.
        mkSectionName =
          name: lib.concatStrings (lib.lists.init (builtins.tail (lib.stringToCharacters name)));
      };
      populateSet =
        components:
        let
          # Weird case is for decoration
          default =
            if builtins.isAttrs components && builtins.hasAttr "normal" components then
              components.normal
            else if builtins.isAttrs components && builtins.hasAttr "focus" components then
              components.focus
            else
              components;
        in
        # Note that not all attributes are used by a given component set so many will be defaulted
        lib.genAttrs [
          "normal"
          "alternate"
          "hover"
          "focus"
          "hover"
          "active"
          "inactive"
          "visited"
          "negative"
          "neutral"
          "positive"
          "disabled"
          "selection"
          "positive-selection"
          "negative-selection"
        ] (name: components.${name} or default);

      bg = populateSet spec.bg;
      fg = populateSet spec.fg;
      decoration = populateSet spec.decoration;
      link = populateSet spec.link;
      button = populateSet spec.button;
      effects = populateSet spec.effects;
    in
    generator {
      "[General]" =
        if overrides.General or false then
          overrides.General
        else
          {
            Name = spec.name;
            ColorScheme = spec.identifier;
          };

      "[Colors:Window]" =
        if overrides.ColorsWindow or false then
          overrides.ColorsWindow
        else
          {
            BackgroundAlternate = bg.alternate;
            BackgroundNormal = bg.normal;
            DecorationFocus = decoration.focus;
            DecorationHover = decoration.hover;
            ForegroundActive = fg.active;
            ForegroundInactive = fg.inactive;
            ForegroundLink = link.normal;
            ForegroundVisited = link.visited;
            ForegroundNegative = fg.negative;
            ForegroundNeutral = fg.neutral;
            ForegroundNormal = fg.normal;
            ForegroundPositive = fg.positive;
          };

      "[Colors:Header]" =
        if overrides.ColorsHeader or false then
          overrides.ColorsHeader
        else
          {
            BackgroundAlternate = bg.normal;
            BackgroundNormal = bg.alternate;
            DecorationFocus = decoration.focus;
            DecorationHover = decoration.hover;
            ForegroundActive = fg.active;
            ForegroundInactive = fg.inactive;
            ForegroundLink = link.normal;
            ForegroundVisited = link.visited;
            ForegroundNegative = fg.negative;
            ForegroundNeutral = fg.neutral;
            ForegroundNormal = fg.normal;
            ForegroundPositive = fg.positive;
          };

      "[Colors:Header][Inactive]" =
        if overrides.ColorsHeaderInactive or false then
          overrides.ColorsHeaderInactive
        else
          {
            BackgroundAlternate = bg.normal;
            BackgroundNormal = bg.alternate;
            DecorationFocus = decoration.focus;
            DecorationHover = decoration.hover;
            ForegroundActive = fg.active;
            ForegroundInactive = fg.inactive;
            ForegroundLink = link.normal;
            ForegroundVisited = link.visited;
            ForegroundNegative = fg.negative;
            ForegroundNeutral = fg.neutral;
            ForegroundNormal = fg.normal;
            ForegroundPositive = fg.positive;
          };

      "[Colors:View]" =
        if overrides.ColorsView or false then
          overrides.ColorsView
        else
          {
            BackgroundAlternate = bg.alternate;
            BackgroundNormal = bg.normal;
            DecorationFocus = decoration.focus;
            DecorationHover = decoration.hover;
            ForegroundActive = fg.active;
            ForegroundInactive = fg.inactive;
            ForegroundLink = link.normal;
            ForegroundVisited = link.visited;
            ForegroundNegative = fg.negative;
            ForegroundNeutral = fg.neutral;
            ForegroundNormal = fg.normal;
            ForegroundPositive = fg.positive;
          };

      "[Colors:Tooltip]" =
        if overrides.ColorsTooltip or false then
          overrides.ColorsTooltip
        else
          {
            BackgroundAlternate = bg.normal;
            BackgroundNormal = bg.alternate;
            DecorationFocus = decoration.focus;
            DecorationHover = decoration.hover;
            ForegroundActive = fg.active;
            ForegroundInactive = fg.inactive;
            ForegroundLink = link.normal;
            ForegroundVisited = link.visited;
            ForegroundNegative = fg.negative;
            ForegroundNeutral = fg.neutral;
            ForegroundNormal = fg.normal;
            ForegroundPositive = fg.positive;
          };

      "[Colors:Selection]" =
        if overrides.ColorsSelection or false then
          overrides.ColorsSelection
        else
          {
            BackgroundAlternate = bg.selection;
            BackgroundNormal = decoration.focus;
            DecorationFocus = decoration.focus;
            DecorationHover = decoration.hover;
            ForegroundActive = fg.normal;
            ForegroundInactive = fg.inactive;
            ForegroundLink = link.selection;
            ForegroundVisited = link.visited;
            ForegroundNegative = fg.negative-selection;
            ForegroundNeutral = fg.neutral;
            ForegroundNormal = fg.normal;
            ForegroundPositive = fg.positive-selection;
          };

      "[Colors:Complementary]" =
        if overrides.ColorsComplementary or false then
          overrides.ColorsComplementary
        else
          {
            BackgroundAlternate = bg.selection;
            BackgroundNormal = bg.normal;
            DecorationFocus = decoration.focus;
            DecorationHover = decoration.hover;
            ForegroundActive = fg.active;
            ForegroundInactive = fg.inactive;
            ForegroundLink = link.normal;
            ForegroundVisited = link.visited;
            ForegroundNegative = fg.negative;
            ForegroundNeutral = fg.neutral;
            ForegroundNormal = fg.normal;
            ForegroundPositive = fg.positive;
          };

      "[Colors:Button]" =
        if overrides.ColorsButton or false then
          overrides.ColorsButton
        else
          {
            BackgroundAlternate = button.normal;
            BackgroundNormal = button.alternate;
            DecorationFocus = decoration.focus;
            DecorationHover = decoration.hover;
            ForegroundActive = fg.active;
            ForegroundInactive = fg.inactive;
            ForegroundLink = link.normal;
            ForegroundVisited = link.visited;
            ForegroundNegative = fg.negative;
            ForegroundNeutral = fg.neutral;
            ForegroundNormal = fg.normal;
            ForegroundPositive = fg.positive;
          };

      "[ColorEffects:Disabled]" =
        if overrides.ColorEffectsDisabled or false then
          overrides.ColorEffectsDisabled
        else
          {
            Color = effects.disabled;
            ColorAmount = 0;
            ColorEffect = 0;
            ContrastAmount = 0.65;
            ContrastEffect = 1;
            IntensityAmount = 0.1;
            IntensityEffect = 2;
          };

      "[ColorEffects:Inactive]" =
        if overrides.ColorEffectsInactive or false then
          overrides.ColorEffectsInactive
        else
          {
            Color = effects.inactive;
            ColorAmount = 0;
            ColorEffect = 0;
            ContrastAmount = 0.65;
            ContrastEffect = 1;
            IntensityAmount = 0.1;
            IntensityEffect = 2;
          };
    };
}
