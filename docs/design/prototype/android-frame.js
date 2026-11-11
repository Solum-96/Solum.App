// Lightweight Android phone frame (same 402×874 screen as IOSDevice so layouts match).
(function () {
  function SolumAndroidDevice(props) {
    var h = window.React.createElement;
    var dark = !!props.dark, fg = dark ? '#FFFFFF' : '#1F2421';
    var width = props.width || 402, height = props.height || 874;
    var icon = function (d) { return h('svg', { width: 16, height: 16, viewBox: '0 0 24 24', fill: fg }, h('path', { d: d })); };
    return h('div', { style: { width: width, height: height, borderRadius: 34, overflow: 'hidden', position: 'relative', background: dark ? '#000' : '#F2F2F2', boxShadow: '0 40px 80px rgba(0,0,0,0.18), 0 0 0 1px rgba(0,0,0,0.12)', fontFamily: 'Roboto, system-ui, sans-serif' } },
      h('div', { style: { position: 'absolute', top: 14, left: '50%', width: 12, height: 12, marginLeft: -6, borderRadius: 999, background: '#000', zIndex: 50 } }),
      h('div', { style: { position: 'absolute', top: 0, left: 0, right: 0, height: 40, zIndex: 10, display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '0 24px', color: fg, font: '500 14px/1 Roboto, system-ui, sans-serif', pointerEvents: 'none' } },
        h('span', null, '9:30'),
        h('span', { style: { display: 'flex', gap: 4, alignItems: 'center' } },
          icon('M12 4C7.3 4 3.1 5.8 0 8.8L12 21 24 8.8C20.9 5.8 16.7 4 12 4z'),
          icon('M2 22h20V2z'),
          icon('M15.7 4H14V2h-4v2H8.3C7.6 4 7 4.6 7 5.3v15.3c0 .8.6 1.4 1.3 1.4h7.3c.7 0 1.3-.6 1.3-1.3V5.3C17 4.6 16.4 4 15.7 4z'))),
      h('div', { style: { height: '100%' } }, props.children),
      h('div', { style: { position: 'absolute', bottom: 0, left: 0, right: 0, height: 24, zIndex: 60, display: 'flex', justifyContent: 'center', alignItems: 'center', pointerEvents: 'none' } },
        h('div', { style: { width: 108, height: 4, borderRadius: 100, background: dark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.35)' } })));
  }
  window.SolumAndroidDevice = SolumAndroidDevice;
})();
