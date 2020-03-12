HTMLWidgets.widget({
  name: "tradingview",
  type: "output",
  factory(el, width, height) {
    let tradingview = new Tradingview(el, width, height);
    return {
      renderValue(x) {
        tradingview.render(x);
      },
      resize(width, height) {
        tradingview.resize(width, height);
      },
      tradingview
    };
  }
});
