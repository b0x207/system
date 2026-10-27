# Firefox Customization Tips

## Inspect Pop-up Styles
To inspect styles on native-UI browser pop-ups, you can trigger the element using the
`Use in console` feature followed by calling `click()` manually on it. Then, simply trigger the
element picker (top left) and when the main window regains focus, the popup will appear.
Unfortunately, you must run the `click()` function every time you want to use the picker as
switching back to the inspect window will cause the pop-up to close as usual
