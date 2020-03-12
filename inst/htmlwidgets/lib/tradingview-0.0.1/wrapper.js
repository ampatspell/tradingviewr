class Tradingview {

  constructor(el, width, height) {
    this.el = el;
    this.width = width;
    this.height = height;
    this.createChart();
    this.bind();
  }

  createChart() {
    let { el, width, height } = this;
    this.chart = LightweightCharts.createChart(el, {
      width,
      height,
      localization: {
        priceFormatter: price => price.toFixed(5)
      }
    });
    this.chart.applyOptions({
      priceScale: {
        borderColor: 'rgba(70, 130, 180, 0.3)',
        scaleMargins: {
          top: 0,
          bottom: 0
        }
      },
      timeScale: {
        borderColor: 'rgba(70, 130, 180, 0.3)',
        timeVisible: true,
      },
      crosshair: {
        vertLine: {
          color: 'rgba(70, 130, 180, 0.5)',
          width: 0.5,
          style: 1,
          visible: true,
          labelVisible: false,
        },
        horzLine: {
          color: 'rgba(70, 130, 180, 0.5)',
          width: 0.5,
          style: 1,
          visible: true,
          labelVisible: true,
        },
        mode: 0
      },
      grid: {
        vertLines: {
          color: 'rgba(70, 130, 180, 0.2)',
          style: 1,
          visible: true
        },
        horzLines: {
          color: 'rgba(70, 130, 180, 0.2)',
          style: 1,
          visible: true
        }
      }
    });
  }

  bind() {
    let body = document.body;
    let setEnabled = enabled => {
      body.setAttribute('style', `pointer-events: ${enabled ? 'all' : 'none'}`);
    };
    setEnabled(false);
    body.addEventListener('keydown', e => setEnabled(e.shiftKey));
    body.addEventListener('keyup', () => setEnabled(false));
  }

  normalizeData(data) {
    if(Array.isArray(data)) {
      data = data.map(item => this.normalizeData(item));
    } else if(typeof data === 'object') {
      for(let key in data) {
        let value = data[key];
        if(key === 'time') {
          data[key] = new Date(value).getTime() / 1000;
        } else {
          data[key] = this.normalizeData(value);
        }
      }
    }
    return data;
  }

  boolean(value, fallback) {
    if(typeof value === 'undefined') {
      return fallback;
    }
    return !!value;
  }

  number(value, fallback) {
    if(typeof value === 'undefined') {
      return fallback;
    }
    return value;
  }

  scaleMargins(margins) {
    if(!margins) {
      return null;
    }
    let { top, bottom } = margins;
    return {
      top: this.number(top, 0),
      bottom: this.number(bottom, 0)
    };
  }

  lookup(key) {
    if(!key) {
      return this.data;
    }
    return this.data[key];
  }

  string(value, fallback) {
    if(typeof value === 'undefined') {
      return fallback;
    }
    return value;
  }

  lineStyle(value) {
    if(value === 'dotted') {
      return 1;
    } else if(value === 'dashed') {
      return 2;
    } else if(value === 'large-dashed') {
      return 3;
    } else if(value === 'sparse-dotted') {
      return 4;
    }
    return 0;
  }

  lineType(value) {
    if(value === 'steps') {
      return 1;
    }
    return 0;
  }

  addLine(key, settings) {
    let series = this.chart.addLineSeries({
      lineWidth: this.number(settings.width, 1),
      overlay: this.boolean(settings.overlay, false),
      scaleMargins: this.scaleMargins(settings.margins),
      lineStyle: this.lineStyle(settings.style),
      color: this.string(settings.color, '#2196f3'),
      crosshairMarkerVisible: true,
      crosshairMarkerRadius: 2,
    });

    let data = this.lookup(settings.data);

    let time = this.string(settings.time, 'time');
    let value = this.string(settings.value, 'value');

    let payload = data.map(item => ({
      time: item[time],
      value: item[value]
    }));

    series.setData(payload);
  }

  addHistogram(key, settings) {
    let series = this.chart.addHistogramSeries({
      base: this.number(settings.base, null),
      color: this.string(settings.color, '#FFF5EE'),
      overlay: this.boolean(settings.overlay, false),
      scaleMargins: this.scaleMargins(settings.margins)
    });

    let data = this.lookup(settings.data);

    let time = this.string(settings.time, 'time');
    let value = this.string(settings.value, 'value');
    let color = this.string(settings.color, 'color');

    series.setData(data.map(item => ({
      time: item[time],
      value: item[value],
      color: item[color]
    })));
  }

  addCandles(key, settings) {
    let series = this.chart.addCandlestickSeries({
      overlay: this.boolean(settings.overlay, false),
      scaleMargins: this.scaleMargins(settings.margins)
    });

    let data = this.lookup(settings.data);

    let time = this.string(settings.time, 'time');
    let open = this.string(settings.open, 'open');
    let close = this.string(settings.close, 'close');
    let high = this.string(settings.high, 'high');
    let low = this.string(settings.low, 'low');

    series.setData(data.map(item => ({
      time: item[time],
      open: item[open],
      close: item[close],
      high: item[high],
      low: item[low]
    })));
  }

  add(key, settings) {
    let { type } = settings;
    if(type === 'line') {
      this.addLine(key, settings);
    } else if(type === 'candles') {
      this.addCandles(key, settings);
    } else if(type === 'histogram') {
      this.addHistogram(key, settings);
    }
  }

  render(x) {
    let { data, type, settings } = x;
    if(type == "data.frame") {
      data = HTMLWidgets.dataframeToD3(data);
    }
    this.data = this.normalizeData(data);
    for(let key in settings) {
      let value = settings[key];
      this.add(key, value);
    }
  }

  resize(width, height) {
    this.chart.resize(width, height);
  }

}