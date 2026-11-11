/* @ds-bundle: {"format":4,"namespace":"SolumDesignSystem_d48af3","components":[{"name":"Button","sourcePath":"components/core/Button.jsx"},{"name":"Icon","sourcePath":"components/core/Icon.jsx"},{"name":"IconButton","sourcePath":"components/core/IconButton.jsx"},{"name":"Logo","sourcePath":"components/core/Logo.jsx"},{"name":"ContactRow","sourcePath":"components/crm/ContactRow.jsx"},{"name":"Badge","sourcePath":"components/feedback/Badge.jsx"},{"name":"ProgressBar","sourcePath":"components/feedback/ProgressBar.jsx"},{"name":"Toast","sourcePath":"components/feedback/Toast.jsx"},{"name":"Checkbox","sourcePath":"components/forms/Checkbox.jsx"},{"name":"Chip","sourcePath":"components/forms/Chip.jsx"},{"name":"Switch","sourcePath":"components/forms/Switch.jsx"},{"name":"TextField","sourcePath":"components/forms/TextField.jsx"},{"name":"AreaProgress","sourcePath":"components/map/AreaProgress.jsx"},{"name":"GreetingCard","sourcePath":"components/map/GreetingCard.jsx"},{"name":"MapPin","sourcePath":"components/map/MapPin.jsx"},{"name":"BottomSheet","sourcePath":"components/surfaces/BottomSheet.jsx"},{"name":"Card","sourcePath":"components/surfaces/Card.jsx"}],"sourceHashes":{"components/core/Button.jsx":"c21039e5523a","components/core/Icon.jsx":"0e16e23aa7b7","components/core/IconButton.jsx":"0250dd042c5f","components/core/Logo.jsx":"d79e1e66d530","components/crm/ContactRow.jsx":"10fc37707206","components/feedback/Badge.jsx":"f5a0640f39eb","components/feedback/ProgressBar.jsx":"364a80869fe4","components/feedback/Toast.jsx":"ed357dfa54e7","components/forms/Checkbox.jsx":"6597dcc84a53","components/forms/Chip.jsx":"ef3f2c44ecdd","components/forms/Switch.jsx":"6be2b6de1082","components/forms/TextField.jsx":"862c66bb60d0","components/map/AreaProgress.jsx":"fb7fa83f9cd0","components/map/GreetingCard.jsx":"a2dc5e06359c","components/map/MapPin.jsx":"caa421036479","components/surfaces/BottomSheet.jsx":"00593bd67e51","components/surfaces/Card.jsx":"d7845b707937","ui_kits/app/ContactScreen.jsx":"89b86fa41cc5","ui_kits/app/ListScreen.jsx":"6a0fd7000c4d","ui_kits/app/MapCanvas.jsx":"de1528b64580","ui_kits/app/MapScreen.jsx":"a822a2fbd38c","ui_kits/app/Sheets.jsx":"c598b5bc7329","ui_kits/app/data.js":"beac7803e4b5"},"inlinedExternals":[],"unexposedExports":[]} */

(() => {

const __ds_ns = (window.SolumDesignSystem_d48af3 = window.SolumDesignSystem_d48af3 || {});

const __ds_scope = {};

(__ds_ns.__errors = __ds_ns.__errors || []);

// components/core/Icon.jsx
try { (() => {
const LUCIDE = 'https://cdn.jsdelivr.net/npm/lucide-static@0.454.0/icons/';
function Icon({
  name,
  size = 24,
  color = 'currentColor',
  label,
  style
}) {
  const url = 'url(' + LUCIDE + name + '.svg)';
  return /*#__PURE__*/React.createElement("span", {
    role: label ? 'img' : undefined,
    "aria-label": label,
    "aria-hidden": label ? undefined : true,
    style: {
      display: 'inline-block',
      flex: 'none',
      width: size,
      height: size,
      background: color,
      WebkitMaskImage: url,
      maskImage: url,
      WebkitMaskSize: '100% 100%',
      maskSize: '100% 100%',
      WebkitMaskRepeat: 'no-repeat',
      maskRepeat: 'no-repeat',
      ...style
    }
  });
}
Object.assign(__ds_scope, { Icon });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Icon.jsx", error: String((e && e.message) || e) }); }

// components/core/Button.jsx
try { (() => {
const V = {
  primary: {
    background: 'var(--olive)',
    color: 'var(--on-olive)',
    border: '0'
  },
  dark: {
    background: 'var(--basalt)',
    color: 'var(--on-basalt)',
    border: '0'
  },
  signal: {
    background: 'var(--sol)',
    color: 'var(--on-sol)',
    border: '0'
  },
  secondary: {
    background: 'var(--surface-raised)',
    color: 'var(--ink)',
    border: '1.5px solid var(--sandstone)'
  },
  ghost: {
    background: 'transparent',
    color: 'var(--ink)',
    border: '0'
  }
};
const S = {
  lg: {
    h: 54,
    px: 24,
    fs: 17
  },
  md: {
    h: 44,
    px: 20,
    fs: 16
  },
  sm: {
    h: 36,
    px: 14,
    fs: 14
  }
};
function Button({
  variant = 'primary',
  size = 'lg',
  icon,
  fullWidth,
  disabled,
  children,
  onClick,
  type = 'button',
  style
}) {
  const v = V[variant] || V.primary,
    s = S[size] || S.lg;
  const [down, setDown] = React.useState(false);
  return /*#__PURE__*/React.createElement("button", {
    type: type,
    disabled: disabled,
    onClick: onClick,
    onPointerDown: () => setDown(true),
    onPointerUp: () => setDown(false),
    onPointerLeave: () => setDown(false),
    style: {
      ...v,
      height: s.h,
      minHeight: 'var(--touch-min)',
      padding: '0 ' + s.px + 'px',
      borderRadius: 'var(--radius-pill)',
      font: '700 ' + s.fs + 'px/1 var(--font-sans)',
      letterSpacing: '-0.005em',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      gap: 8,
      width: fullWidth ? '100%' : undefined,
      cursor: disabled ? 'default' : 'pointer',
      opacity: disabled ? 0.4 : 1,
      transform: down && !disabled ? 'scale(0.98)' : 'none',
      filter: down && !disabled ? 'brightness(0.92)' : 'none',
      transition: 'transform var(--duration-fast) var(--ease-out), filter var(--duration-fast)',
      WebkitTapHighlightColor: 'transparent',
      ...style
    }
  }, icon ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: icon,
    size: s.h >= 54 ? 22 : 20
  }) : null, children);
}
Object.assign(__ds_scope, { Button });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Button.jsx", error: String((e && e.message) || e) }); }

// components/core/IconButton.jsx
try { (() => {
const V = {
  raised: {
    background: 'var(--surface-raised)',
    color: 'var(--ink)',
    boxShadow: 'var(--shadow-float)'
  },
  plain: {
    background: 'transparent',
    color: 'var(--ink)'
  },
  dark: {
    background: 'var(--basalt)',
    color: 'var(--on-basalt)'
  },
  tint: {
    background: 'var(--sandstone)',
    color: 'var(--ink)'
  }
};
function IconButton({
  icon,
  label,
  variant = 'raised',
  size = 44,
  onClick,
  style
}) {
  return /*#__PURE__*/React.createElement("button", {
    type: "button",
    "aria-label": label,
    title: label,
    onClick: onClick,
    style: {
      ...V[variant],
      width: size,
      height: size,
      minWidth: 44,
      minHeight: 44,
      borderRadius: 'var(--radius-pill)',
      border: 0,
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      cursor: 'pointer',
      padding: 0,
      WebkitTapHighlightColor: 'transparent',
      ...style
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: icon,
    size: 22
  }));
}
Object.assign(__ds_scope, { IconButton });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/IconButton.jsx", error: String((e && e.message) || e) }); }

// components/core/Logo.jsx
try { (() => {
// Path data extracted verbatim from the Solum Brand Book v1 (logo page). Do not redraw.
const L = {
  "mark": {
    "vb": "2725 1518.75 200 200",
    "p": []
  },
  "lockup": {
    "vb": "337.5 946.88 703.13 156.25",
    "p": []
  },
  "stacked": {
    "vb": "415.63 1428.13 546.88 381.25",
    "p": []
  }
};
const TONES = {
  color: {
    dot: 'var(--sol, #E9B949)',
    ink: 'var(--ink, #1F2421)'
  },
  reverse: {
    dot: 'var(--sol, #E9B949)',
    ink: '#FFFFFF'
  },
  mono: {
    dot: 'currentColor',
    ink: 'currentColor'
  },
  white: {
    dot: '#FFFFFF',
    ink: '#FFFFFF'
  }
};
function Logo({
  variant = 'lockup',
  tone = 'color',
  height = 32,
  title = 'Solum',
  style
}) {
  const l = L[variant] || L.lockup,
    t = TONES[tone] || TONES.color;
  const [,, w, h] = l.vb.split(' ').map(Number);
  return /*#__PURE__*/React.createElement("svg", {
    viewBox: l.vb,
    height: height,
    width: height * w / h,
    role: "img",
    "aria-label": title,
    style: {
      display: 'block',
      flex: 'none',
      ...style
    }
  }, l.p.map(([role, d], i) => /*#__PURE__*/React.createElement("path", {
    key: i,
    fill: t[role],
    d: d
  })));
}
Object.assign(__ds_scope, { Logo });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Logo.jsx", error: String((e && e.message) || e) }); }

// components/feedback/Badge.jsx
try { (() => {
const T = {
  followup: {
    background: 'var(--sol-tint)',
    color: 'var(--on-sol-tint)',
    dot: 'var(--sol)'
  },
  visited: {
    background: 'rgba(77,91,46,.12)',
    color: 'var(--olive)',
    dot: 'var(--olive)'
  },
  neutral: {
    background: 'var(--sandstone)',
    color: 'var(--ink)',
    dot: null
  },
  dark: {
    background: 'var(--basalt)',
    color: 'var(--on-basalt)',
    dot: null
  }
};
function Badge({
  tone = 'neutral',
  dot,
  children,
  style
}) {
  const t = T[tone] || T.neutral;
  return /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 6,
      height: 26,
      padding: '0 10px',
      borderRadius: 'var(--radius-sm)',
      background: t.background,
      color: t.color,
      font: '700 13px/1 var(--font-sans)',
      whiteSpace: 'nowrap',
      ...style
    }
  }, dot && t.dot ? /*#__PURE__*/React.createElement("span", {
    style: {
      width: 8,
      height: 8,
      borderRadius: 999,
      background: t.dot,
      boxShadow: tone === 'followup' ? 'inset 0 0 0 1.5px var(--ink)' : 'none'
    }
  }) : null, children);
}
Object.assign(__ds_scope, { Badge });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/feedback/Badge.jsx", error: String((e && e.message) || e) }); }

// components/feedback/ProgressBar.jsx
try { (() => {
function ProgressBar({
  value = 0,
  max = 100,
  height = 8,
  label,
  style
}) {
  const pct = Math.max(0, Math.min(1, value / (max || 1))) * 100;
  return /*#__PURE__*/React.createElement("div", {
    role: "progressbar",
    "aria-valuenow": value,
    "aria-valuemin": 0,
    "aria-valuemax": max,
    "aria-label": label,
    style: {
      height,
      borderRadius: 999,
      background: 'var(--progress-track)',
      overflow: 'hidden',
      ...style
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: pct + '%',
      height: '100%',
      borderRadius: 999,
      background: 'var(--progress-fill)',
      transition: 'width var(--duration-sheet) var(--ease-out)'
    }
  }));
}
Object.assign(__ds_scope, { ProgressBar });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/feedback/ProgressBar.jsx", error: String((e && e.message) || e) }); }

// components/feedback/Toast.jsx
try { (() => {
function Toast({
  icon = 'circle-check',
  children,
  action,
  onAction,
  style
}) {
  return /*#__PURE__*/React.createElement("div", {
    role: "status",
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 12,
      minHeight: 52,
      padding: '0 8px 0 16px',
      borderRadius: 'var(--radius-md)',
      background: 'var(--basalt)',
      color: 'var(--on-basalt)',
      font: '500 15px/20px var(--font-sans)',
      boxShadow: 'var(--shadow-float)',
      ...style
    }
  }, icon ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: icon,
    size: 20,
    color: "var(--sol)"
  }) : null, /*#__PURE__*/React.createElement("span", {
    style: {
      flex: 1,
      padding: '14px 0'
    }
  }, children), action ? /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: onAction,
    style: {
      minHeight: 44,
      padding: '0 12px',
      border: 0,
      background: 'transparent',
      color: 'var(--sol)',
      font: '700 15px/1 var(--font-sans)',
      cursor: 'pointer'
    }
  }, action) : null);
}
Object.assign(__ds_scope, { Toast });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/feedback/Toast.jsx", error: String((e && e.message) || e) }); }

// components/forms/Checkbox.jsx
try { (() => {
function Checkbox({
  checked,
  onChange,
  label,
  style
}) {
  return /*#__PURE__*/React.createElement("label", {
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 12,
      minHeight: 44,
      cursor: 'pointer',
      font: '400 16px/24px var(--font-sans)',
      color: 'var(--ink)',
      ...style
    }
  }, /*#__PURE__*/React.createElement("input", {
    type: "checkbox",
    checked: !!checked,
    onChange: e => onChange && onChange(e.target.checked),
    style: {
      position: 'absolute',
      opacity: 0,
      width: 0,
      height: 0
    }
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      width: 24,
      height: 24,
      borderRadius: 7,
      flex: 'none',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      background: checked ? 'var(--olive)' : 'var(--surface-raised)',
      border: checked ? '0' : '2px solid var(--ink)',
      color: 'var(--on-olive)',
      transition: 'background var(--duration-fast)'
    }
  }, checked ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: "check",
    size: 16
  }) : null), label);
}
Object.assign(__ds_scope, { Checkbox });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/Checkbox.jsx", error: String((e && e.message) || e) }); }

// components/forms/Chip.jsx
try { (() => {
function Chip({
  selected,
  icon,
  count,
  children,
  onClick,
  floating,
  style
}) {
  return /*#__PURE__*/React.createElement("button", {
    type: "button",
    "aria-pressed": !!selected,
    onClick: onClick,
    style: {
      height: 'var(--chip-height)',
      minHeight: 'var(--touch-min)',
      padding: '0 14px',
      borderRadius: 'var(--radius-pill)',
      border: selected ? '0' : '1.5px solid var(--sandstone)',
      background: selected ? 'var(--olive)' : 'var(--surface-raised)',
      color: selected ? 'var(--on-olive)' : 'var(--ink)',
      font: '700 14px/1 var(--font-sans)',
      display: 'inline-flex',
      alignItems: 'center',
      gap: 6,
      cursor: 'pointer',
      whiteSpace: 'nowrap',
      boxShadow: floating ? 'var(--shadow-float)' : 'none',
      transition: 'background var(--duration-fast), color var(--duration-fast)',
      WebkitTapHighlightColor: 'transparent',
      ...style
    }
  }, icon ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: icon,
    size: 16
  }) : null, children, count != null ? /*#__PURE__*/React.createElement("span", {
    style: {
      font: '700 12px/1 var(--font-sans)',
      padding: '3px 6px',
      borderRadius: 999,
      background: selected ? 'rgba(255,255,255,.16)' : 'var(--surface)',
      color: 'inherit'
    }
  }, count) : null);
}
Object.assign(__ds_scope, { Chip });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/Chip.jsx", error: String((e && e.message) || e) }); }

// components/forms/Switch.jsx
try { (() => {
function Switch({
  checked,
  onChange,
  label,
  style
}) {
  return /*#__PURE__*/React.createElement("label", {
    style: {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      gap: 16,
      minHeight: 44,
      cursor: 'pointer',
      font: '400 16px/24px var(--font-sans)',
      color: 'var(--ink)',
      ...style
    }
  }, label, /*#__PURE__*/React.createElement("button", {
    type: "button",
    role: "switch",
    "aria-checked": !!checked,
    onClick: () => onChange && onChange(!checked),
    style: {
      width: 52,
      height: 32,
      borderRadius: 999,
      border: 0,
      padding: 3,
      flex: 'none',
      cursor: 'pointer',
      background: checked ? 'var(--olive)' : 'var(--sandstone)',
      transition: 'background var(--duration-base) var(--ease-out)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'block',
      width: 26,
      height: 26,
      borderRadius: 999,
      background: 'var(--white)',
      transform: checked ? 'translateX(20px)' : 'none',
      transition: 'transform var(--duration-base) var(--ease-out)',
      boxShadow: '0 1px 2px rgba(31,36,33,.2)'
    }
  })));
}
Object.assign(__ds_scope, { Switch });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/Switch.jsx", error: String((e && e.message) || e) }); }

// components/forms/TextField.jsx
try { (() => {
function TextField({
  label,
  value,
  placeholder,
  onChange,
  icon,
  multiline,
  rows = 3,
  hint,
  type = 'text',
  style
}) {
  const [focus, setFocus] = React.useState(false);
  const Tag = multiline ? 'textarea' : 'input';
  return /*#__PURE__*/React.createElement("label", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 6,
      ...style
    }
  }, label ? /*#__PURE__*/React.createElement("span", {
    style: {
      font: '700 13px/16px var(--font-sans)',
      letterSpacing: '0.06em',
      textTransform: 'uppercase',
      color: 'var(--ink-muted)'
    }
  }, label) : null, /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'flex',
      alignItems: multiline ? 'flex-start' : 'center',
      gap: 10,
      minHeight: 52,
      padding: multiline ? '14px 16px' : '0 16px',
      background: 'var(--surface-raised)',
      borderRadius: 'var(--radius-md)',
      border: '1.5px solid ' + (focus ? 'var(--olive)' : 'var(--sandstone)'),
      transition: 'border-color var(--duration-fast)'
    }
  }, icon ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: icon,
    size: 20,
    color: "var(--ink-muted)"
  }) : null, /*#__PURE__*/React.createElement(Tag, {
    type: multiline ? undefined : type,
    rows: multiline ? rows : undefined,
    value: value,
    placeholder: placeholder,
    onChange: onChange,
    onFocus: () => setFocus(true),
    onBlur: () => setFocus(false),
    style: {
      flex: 1,
      minWidth: 0,
      border: 0,
      outline: 'none',
      background: 'transparent',
      resize: 'none',
      padding: 0,
      font: '400 16px/24px var(--font-sans)',
      color: 'var(--ink)'
    }
  })), hint ? /*#__PURE__*/React.createElement("span", {
    style: {
      font: '500 14px/20px var(--font-sans)',
      color: 'var(--ink-muted)'
    }
  }, hint) : null);
}
Object.assign(__ds_scope, { TextField });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/TextField.jsx", error: String((e && e.message) || e) }); }

// components/map/AreaProgress.jsx
try { (() => {
function AreaProgress({
  area,
  visited = 0,
  total = 0,
  style
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 10,
      ...style
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      font: '700 13px/16px var(--font-sans)',
      letterSpacing: '0.06em',
      textTransform: 'uppercase',
      color: 'var(--ink-muted)'
    }
  }, area), /*#__PURE__*/React.createElement("div", {
    style: {
      font: '800 26px/32px var(--font-sans)',
      letterSpacing: '-0.02em',
      color: 'var(--ink)'
    }
  }, visited, " of ", total, " visited"), /*#__PURE__*/React.createElement(__ds_scope.ProgressBar, {
    value: visited,
    max: total,
    height: 8,
    label: area + ' coverage'
  }));
}
Object.assign(__ds_scope, { AreaProgress });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/map/AreaProgress.jsx", error: String((e && e.message) || e) }); }

// components/map/GreetingCard.jsx
try { (() => {
function GreetingCard({
  greeting,
  headline,
  detail,
  onClick,
  style
}) {
  return /*#__PURE__*/React.createElement("div", {
    onClick: onClick,
    style: {
      background: 'var(--basalt)',
      color: 'var(--on-basalt)',
      borderRadius: 'var(--radius-md)',
      padding: '16px 18px',
      display: 'flex',
      alignItems: 'center',
      gap: 14,
      boxShadow: 'var(--shadow-float)',
      cursor: onClick ? 'pointer' : undefined,
      ...style
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      width: 14,
      height: 14,
      borderRadius: 999,
      background: 'var(--sol)',
      flex: 'none'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 2,
      minWidth: 0
    }
  }, greeting ? /*#__PURE__*/React.createElement("span", {
    style: {
      font: '500 14px/20px var(--font-sans)',
      color: 'rgba(255,255,255,.72)'
    }
  }, greeting) : null, /*#__PURE__*/React.createElement("span", {
    style: {
      font: '700 18px/24px var(--font-sans)',
      letterSpacing: '-0.01em'
    }
  }, headline), detail ? /*#__PURE__*/React.createElement("span", {
    style: {
      font: '500 14px/20px var(--font-sans)',
      color: 'rgba(255,255,255,.72)'
    }
  }, detail) : null));
}
Object.assign(__ds_scope, { GreetingCard });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/map/GreetingCard.jsx", error: String((e && e.message) || e) }); }

// components/map/MapPin.jsx
try { (() => {
function MapPin({
  state = 'unvisited',
  size,
  label,
  onClick,
  selected,
  style
}) {
  const d = size || (state === 'followup' ? 18 : 16);
  const base = {
    unvisited: {
      background: 'var(--pin-unvisited-fill)',
      boxShadow: 'inset 0 0 0 3px var(--pin-unvisited-ring)'
    },
    visited: {
      background: 'var(--pin-visited)',
      boxShadow: 'none'
    },
    followup: {
      background: 'var(--pin-followup-fill)',
      boxShadow: 'inset 0 0 0 3px var(--pin-followup-ring)'
    }
  }[state];
  return /*#__PURE__*/React.createElement("span", {
    role: onClick ? 'button' : 'img',
    "aria-label": label || state,
    onClick: onClick,
    style: {
      display: 'inline-block',
      width: d,
      height: d,
      borderRadius: 999,
      flex: 'none',
      cursor: onClick ? 'pointer' : undefined,
      outline: selected ? '3px solid var(--white)' : 'none',
      ...base,
      filter: selected ? 'drop-shadow(0 2px 4px rgba(31,36,33,.35))' : 'none',
      transform: selected ? 'scale(1.35)' : 'none',
      transition: 'transform var(--duration-fast) var(--ease-out)',
      ...style
    }
  });
}
Object.assign(__ds_scope, { MapPin });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/map/MapPin.jsx", error: String((e && e.message) || e) }); }

// components/crm/ContactRow.jsx
try { (() => {
function ContactRow({
  name,
  address,
  meta,
  state = 'unvisited',
  trailing,
  onClick,
  divider = true,
  style
}) {
  return /*#__PURE__*/React.createElement("div", {
    onClick: onClick,
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 14,
      minHeight: 64,
      padding: '10px 0',
      borderBottom: divider ? '1px solid var(--divider)' : '0',
      cursor: onClick ? 'pointer' : undefined,
      ...style
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      width: 24,
      display: 'flex',
      justifyContent: 'center',
      flex: 'none'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.MapPin, {
    state: state
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      minWidth: 0,
      display: 'flex',
      flexDirection: 'column',
      gap: 2
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      font: '700 16px/22px var(--font-sans)',
      color: 'var(--ink)',
      overflow: 'hidden',
      textOverflow: 'ellipsis',
      whiteSpace: 'nowrap'
    }
  }, name), address ? /*#__PURE__*/React.createElement("span", {
    style: {
      font: '500 14px/20px var(--font-sans)',
      color: 'var(--ink-muted)',
      overflow: 'hidden',
      textOverflow: 'ellipsis',
      whiteSpace: 'nowrap'
    }
  }, address) : null), meta ? /*#__PURE__*/React.createElement("span", {
    style: {
      flex: 'none'
    }
  }, meta) : null, trailing !== undefined ? trailing : onClick ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: "chevron-right",
    size: 20,
    color: "var(--ink-muted)"
  }) : null);
}
Object.assign(__ds_scope, { ContactRow });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/crm/ContactRow.jsx", error: String((e && e.message) || e) }); }

// components/surfaces/BottomSheet.jsx
try { (() => {
function BottomSheet({
  children,
  actions,
  handle = true,
  style
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      background: 'var(--surface-raised)',
      borderRadius: 'var(--radius-lg) var(--radius-lg) 0 0',
      boxShadow: 'var(--shadow-sheet)',
      padding: '10px var(--sheet-padding) calc(var(--sheet-padding) + env(safe-area-inset-bottom, 0px))',
      display: 'flex',
      flexDirection: 'column',
      gap: 16,
      ...style
    }
  }, handle ? /*#__PURE__*/React.createElement("div", {
    style: {
      width: 40,
      height: 5,
      borderRadius: 999,
      background: 'var(--sandstone)',
      alignSelf: 'center',
      marginBottom: 2
    }
  }) : null, children, actions ? /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 12
    }
  }, actions) : null);
}
Object.assign(__ds_scope, { BottomSheet });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/surfaces/BottomSheet.jsx", error: String((e && e.message) || e) }); }

// components/surfaces/Card.jsx
try { (() => {
const T = {
  raised: {
    background: 'var(--surface-raised)',
    color: 'var(--ink)'
  },
  inverse: {
    background: 'var(--basalt)',
    color: 'var(--on-basalt)'
  },
  sunken: {
    background: 'var(--sandstone)',
    color: 'var(--ink)'
  },
  tint: {
    background: 'var(--sol-tint)',
    color: 'var(--ink)'
  }
};
function Card({
  tone = 'raised',
  padding = 20,
  floating,
  onClick,
  children,
  style
}) {
  return /*#__PURE__*/React.createElement("div", {
    onClick: onClick,
    style: {
      ...(T[tone] || T.raised),
      borderRadius: 'var(--radius-md)',
      padding,
      boxShadow: floating ? 'var(--shadow-float)' : 'none',
      cursor: onClick ? 'pointer' : undefined,
      ...style
    }
  }, children);
}
Object.assign(__ds_scope, { Card });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/surfaces/Card.jsx", error: String((e && e.message) || e) }); }

// ui_kits/app/ContactScreen.jsx
try { (() => {
function ContactScreen({
  stop,
  back,
  nav
}) {
  const {
    IconButton,
    Button,
    Badge,
    Card,
    MapPin,
    Icon
  } = window.SolumDesignSystem_d48af3;
  const history = stop.state === 'unvisited' ? [] : [['Tue', 'Spoke with them · left a flyer'], ['Mon', 'Not home']];
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      background: 'var(--surface)',
      display: 'flex',
      flexDirection: 'column'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '56px 16px 0',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between'
    }
  }, /*#__PURE__*/React.createElement(IconButton, {
    icon: "chevron-left",
    label: "Back",
    variant: "plain",
    onClick: back
  }), /*#__PURE__*/React.createElement(IconButton, {
    icon: "ellipsis",
    label: "More",
    variant: "plain"
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      overflow: 'auto',
      padding: '8px 16px 16px',
      display: 'flex',
      flexDirection: 'column',
      gap: 16
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 8
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 10
    }
  }, /*#__PURE__*/React.createElement(MapPin, {
    state: stop.state
  }), stop.when ? /*#__PURE__*/React.createElement(Badge, {
    tone: "followup"
  }, "Today, ", stop.when) : /*#__PURE__*/React.createElement(Badge, {
    tone: stop.state === 'visited' ? 'visited' : 'neutral'
  }, stop.state === 'visited' ? 'Visited' : 'Not visited')), /*#__PURE__*/React.createElement("div", {
    className: "solum-title"
  }, stop.name), /*#__PURE__*/React.createElement("div", {
    className: "solum-small",
    style: {
      color: 'var(--ink-muted)'
    }
  }, stop.address, stop.phone ? ' · ' + stop.phone : '')), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 10
    }
  }, /*#__PURE__*/React.createElement(Button, {
    size: "sm",
    variant: "secondary",
    icon: "phone"
  }, "Call"), /*#__PURE__*/React.createElement(Button, {
    size: "sm",
    variant: "secondary",
    icon: "message-square"
  }, "Text"), /*#__PURE__*/React.createElement(Button, {
    size: "sm",
    variant: "secondary",
    icon: "navigation"
  }, "Directions")), stop.note ? /*#__PURE__*/React.createElement(Card, {
    tone: "tint",
    padding: 16
  }, /*#__PURE__*/React.createElement("div", {
    className: "solum-label",
    style: {
      marginBottom: 6
    }
  }, "What to say"), /*#__PURE__*/React.createElement("div", {
    className: "solum-body"
  }, stop.note)) : null, /*#__PURE__*/React.createElement(Card, {
    padding: 16
  }, /*#__PURE__*/React.createElement("div", {
    className: "solum-heading",
    style: {
      marginBottom: 8
    }
  }, "Visits"), history.length ? history.map(([d, t], i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      display: 'flex',
      gap: 12,
      padding: '10px 0',
      borderTop: i ? '1px solid var(--divider)' : 0
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "solum-body-strong",
    style: {
      width: 40
    }
  }, d), /*#__PURE__*/React.createElement("span", {
    className: "solum-body",
    style: {
      color: 'var(--ink-muted)'
    }
  }, t))) : /*#__PURE__*/React.createElement("div", {
    className: "solum-body",
    style: {
      color: 'var(--ink-muted)'
    }
  }, "No visits yet."))), /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '12px 20px 34px',
      display: 'flex',
      gap: 12,
      background: 'var(--surface-raised)',
      borderRadius: '24px 24px 0 0',
      boxShadow: 'var(--shadow-sheet)'
    }
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "dark",
    fullWidth: true,
    onClick: () => nav('log', stop)
  }, "Log visit"), /*#__PURE__*/React.createElement(Button, {
    variant: "signal",
    fullWidth: true,
    onClick: () => nav('follow', stop)
  }, "Follow up")));
}
window.ContactScreen = ContactScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/app/ContactScreen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/app/ListScreen.jsx
try { (() => {
function ListScreen({
  data,
  back,
  nav
}) {
  const {
    IconButton,
    Chip,
    ContactRow,
    Badge,
    Card
  } = window.SolumDesignSystem_d48af3;
  const [tab, setTab] = React.useState('Today');
  const follow = data.stops.filter(s => s.state === 'followup');
  const rest = data.stops.filter(s => s.state !== 'followup' && (tab !== 'Not visited' || s.state === 'unvisited'));
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      background: 'var(--surface)',
      display: 'flex',
      flexDirection: 'column'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '56px 16px 12px',
      display: 'flex',
      flexDirection: 'column',
      gap: 12
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 4
    }
  }, /*#__PURE__*/React.createElement(IconButton, {
    icon: "map",
    label: "Back to map",
    variant: "plain",
    onClick: back
  }), /*#__PURE__*/React.createElement("div", {
    className: "solum-title"
  }, follow.length, " people to see today")), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 8
    }
  }, ['Today', 'This week', 'Not visited'].map(f => /*#__PURE__*/React.createElement(Chip, {
    key: f,
    selected: tab === f,
    onClick: () => setTab(f)
  }, f)))), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      overflow: 'auto',
      padding: '0 16px 24px',
      display: 'flex',
      flexDirection: 'column',
      gap: 16
    }
  }, tab !== 'Not visited' ? /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "solum-label",
    style: {
      color: 'var(--ink-muted)',
      margin: '4px 0 8px'
    }
  }, "Follow-ups"), /*#__PURE__*/React.createElement(Card, {
    padding: 0,
    style: {
      padding: '0 16px'
    }
  }, follow.map((s, i) => /*#__PURE__*/React.createElement(ContactRow, {
    key: s.id,
    state: "followup",
    name: s.name,
    address: s.address,
    divider: i < follow.length - 1,
    meta: /*#__PURE__*/React.createElement(Badge, {
      tone: "followup"
    }, s.when),
    onClick: () => nav('contact', s)
  })))) : null, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "solum-label",
    style: {
      color: 'var(--ink-muted)',
      margin: '4px 0 8px'
    }
  }, "Westgate \xB7 ", rest.length, " stops"), /*#__PURE__*/React.createElement(Card, {
    padding: 0,
    style: {
      padding: '0 16px'
    }
  }, rest.map((s, i) => /*#__PURE__*/React.createElement(ContactRow, {
    key: s.id,
    state: s.state,
    name: s.name,
    address: s.address,
    divider: i < rest.length - 1,
    onClick: () => nav('contact', s)
  }))))));
}
window.ListScreen = ListScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/app/ListScreen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/app/MapCanvas.jsx
try { (() => {
// Stylized placeholder map (no tile provider in the source). Sandstone ground, chalk roads, olive dashed area.
function MapCanvas({
  stops,
  selectedId,
  onSelect,
  outlining,
  filter
}) {
  const {
    MapPin
  } = window.SolumDesignSystem_d48af3;
  const visible = stops.filter(s => filter === 'Not visited' ? s.state === 'unvisited' : filter === 'Today' ? true : true);
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      background: 'var(--map-ground)',
      overflow: 'hidden'
    }
  }, /*#__PURE__*/React.createElement("svg", {
    width: "100%",
    height: "100%",
    viewBox: "0 0 390 844",
    preserveAspectRatio: "xMidYMid slice",
    style: {
      position: 'absolute',
      inset: 0
    }
  }, /*#__PURE__*/React.createElement("g", {
    stroke: "var(--map-road)",
    strokeLinecap: "round",
    fill: "none"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M-20 200 L410 180",
    strokeWidth: "14"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M-20 375 L410 372",
    strokeWidth: "10"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M-20 470 L410 462",
    strokeWidth: "10"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M60 -20 L52 900",
    strokeWidth: "10"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M340 -20 L352 900",
    strokeWidth: "14"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M-20 640 Q200 600 410 680",
    strokeWidth: "10"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M180 470 L186 700",
    strokeWidth: "8"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M-20 90 L410 120",
    strokeWidth: "8"
  })), /*#__PURE__*/React.createElement("g", {
    fill: "#DED5C3"
  }, /*#__PURE__*/React.createElement("rect", {
    x: "250",
    y: "520",
    width: "80",
    height: "80",
    rx: "10"
  }), /*#__PURE__*/React.createElement("rect", {
    x: "76",
    y: "40",
    width: "110",
    height: "60",
    rx: "10"
  })), /*#__PURE__*/React.createElement("path", {
    d: "M70 205 L330 196 L338 455 L195 462 L195 560 L70 560 Z",
    fill: "var(--area-fill)",
    stroke: "var(--area-stroke)",
    strokeWidth: "3",
    strokeDasharray: "8 7",
    strokeLinejoin: "round"
  }), outlining ? /*#__PURE__*/React.createElement("path", {
    d: "M80 640 L250 610 L320 700",
    fill: "none",
    stroke: "var(--olive)",
    strokeWidth: "3",
    strokeDasharray: "8 7",
    strokeLinecap: "round"
  }) : null), visible.map(s => /*#__PURE__*/React.createElement("div", {
    key: s.id,
    style: {
      position: 'absolute',
      left: s.x,
      top: s.y,
      transform: 'translate(-50%,-50%)',
      padding: 13,
      cursor: 'pointer'
    },
    onClick: () => onSelect(s.id)
  }, /*#__PURE__*/React.createElement(MapPin, {
    state: s.state,
    selected: selectedId === s.id,
    label: s.name
  }))), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 180,
      top: 600,
      width: 18,
      height: 18,
      borderRadius: 99,
      background: '#fff',
      boxShadow: '0 0 0 6px rgba(77,91,46,.18)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 10,
      height: 10,
      borderRadius: 99,
      background: 'var(--basalt)'
    }
  })));
}
window.MapCanvas = MapCanvas;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/app/MapCanvas.jsx", error: String((e && e.message) || e) }); }

// ui_kits/app/MapScreen.jsx
try { (() => {
function MapScreen({
  data,
  nav,
  state,
  setState
}) {
  const {
    GreetingCard,
    Chip,
    IconButton,
    Button,
    BottomSheet,
    AreaProgress,
    ContactRow,
    Badge,
    Toast
  } = window.SolumDesignSystem_d48af3;
  const follow = data.stops.filter(s => s.state === 'followup');
  const next = data.stops.find(s => s.id === state.selectedId) || follow[0];
  const visited = data.stops.filter(s => s.state === 'visited').length;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0
    }
  }, /*#__PURE__*/React.createElement(MapCanvas, {
    stops: data.stops,
    selectedId: next && next.id,
    onSelect: id => setState({
      selectedId: id
    }),
    filter: state.filter,
    outlining: state.outlining
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top: 56,
      left: 16,
      right: 16,
      display: 'flex',
      flexDirection: 'column',
      gap: 12
    }
  }, state.outlining ? /*#__PURE__*/React.createElement("div", {
    style: {
      background: 'var(--basalt)',
      color: '#fff',
      borderRadius: 16,
      padding: '14px 16px',
      display: 'flex',
      alignItems: 'center',
      gap: 12,
      boxShadow: 'var(--shadow-float)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      font: '700 16px/22px var(--font-sans)'
    }
  }, "Outline area"), /*#__PURE__*/React.createElement("div", {
    style: {
      font: '500 14px/20px var(--font-sans)',
      opacity: .72
    }
  }, "Tap the map to drop corners")), /*#__PURE__*/React.createElement(Button, {
    size: "sm",
    variant: "signal",
    onClick: () => setState({
      outlining: false,
      toast: 'Area saved · Cedar Park'
    })
  }, "Done")) : /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 10,
      alignItems: 'stretch'
    }
  }, /*#__PURE__*/React.createElement(GreetingCard, {
    style: {
      flex: 1
    },
    greeting: 'Good morning, ' + data.user,
    headline: follow.length + ' people to see today',
    onClick: () => nav('list')
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 8
    }
  }, ['Today', 'This week', 'Not visited'].map(f => /*#__PURE__*/React.createElement(Chip, {
    key: f,
    floating: true,
    selected: state.filter === f,
    onClick: () => setState({
      filter: f
    })
  }, f)))), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      right: 16,
      top: 330,
      display: 'flex',
      flexDirection: 'column',
      gap: 10
    }
  }, /*#__PURE__*/React.createElement(IconButton, {
    icon: "list",
    label: "List",
    onClick: () => nav('list')
  }), /*#__PURE__*/React.createElement(IconButton, {
    icon: "locate-fixed",
    label: "Center on me"
  })), !state.outlining ? /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 16,
      top: 420
    }
  }, /*#__PURE__*/React.createElement(Button, {
    size: "md",
    variant: "secondary",
    icon: "square-dashed",
    onClick: () => setState({
      outlining: true
    }),
    style: {
      boxShadow: 'var(--shadow-float)',
      border: 0
    }
  }, "Outline area")) : null, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 0,
      right: 0,
      bottom: 0
    }
  }, state.toast ? /*#__PURE__*/React.createElement(Toast, {
    action: "Undo",
    onAction: () => setState({
      toast: null
    }),
    style: {
      margin: '0 16px 12px'
    }
  }, state.toast) : null, /*#__PURE__*/React.createElement(BottomSheet, {
    actions: /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(Button, {
      variant: "dark",
      fullWidth: true,
      onClick: () => nav('log', next)
    }, "Log visit"), /*#__PURE__*/React.createElement(Button, {
      variant: "signal",
      fullWidth: true,
      onClick: () => nav('follow', next)
    }, "Follow up"))
  }, /*#__PURE__*/React.createElement(AreaProgress, {
    area: data.area.name,
    visited: data.area.visited + state.logged,
    total: data.area.total
  }), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "solum-label",
    style: {
      color: 'var(--ink-muted)',
      marginTop: 4
    }
  }, "Next stop"), /*#__PURE__*/React.createElement(ContactRow, {
    state: next.state,
    name: next.name,
    address: next.address,
    divider: false,
    meta: next.when ? /*#__PURE__*/React.createElement(Badge, {
      tone: "followup"
    }, next.when) : null,
    onClick: () => nav('contact', next)
  })))));
}
window.MapScreen = MapScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/app/MapScreen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/app/Sheets.jsx
try { (() => {
function SheetFrame({
  title,
  onClose,
  children,
  actions
}) {
  const {
    IconButton,
    BottomSheet
  } = window.SolumDesignSystem_d48af3;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      background: 'var(--scrim)',
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'flex-end'
    },
    onClick: onClose
  }, /*#__PURE__*/React.createElement("div", {
    onClick: e => e.stopPropagation()
  }, /*#__PURE__*/React.createElement(BottomSheet, {
    actions: actions
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      gap: 12
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "solum-heading"
  }, title), /*#__PURE__*/React.createElement(IconButton, {
    icon: "x",
    label: "Close",
    variant: "tint",
    size: 40,
    onClick: onClose
  })), children)));
}
function LogVisitSheet({
  stop,
  onClose,
  onSave
}) {
  const {
    Chip,
    TextField,
    Checkbox,
    Button
  } = window.SolumDesignSystem_d48af3;
  const [outcome, setOutcome] = React.useState('Spoke with them');
  const [flyer, setFlyer] = React.useState(true);
  const [note, setNote] = React.useState('');
  return /*#__PURE__*/React.createElement(SheetFrame, {
    title: 'Log visit · ' + stop.name,
    onClose: onClose,
    actions: /*#__PURE__*/React.createElement(Button, {
      variant: "primary",
      fullWidth: true,
      onClick: onSave
    }, "Save visit")
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "solum-label",
    style: {
      color: 'var(--ink-muted)',
      marginBottom: 10
    }
  }, "Outcome"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 8,
      flexWrap: 'wrap'
    }
  }, ['Spoke with them', 'Not home', 'Not interested', 'Sale'].map(o => /*#__PURE__*/React.createElement(Chip, {
    key: o,
    selected: outcome === o,
    onClick: () => setOutcome(o)
  }, o)))), /*#__PURE__*/React.createElement(TextField, {
    label: "Note",
    multiline: true,
    rows: 2,
    placeholder: "What to say next time",
    value: note,
    onChange: e => setNote(e.target.value)
  }), /*#__PURE__*/React.createElement(Checkbox, {
    checked: flyer,
    onChange: setFlyer,
    label: "Left a flyer"
  }));
}
function FollowUpSheet({
  stop,
  onClose,
  onSave
}) {
  const {
    Chip,
    TextField,
    Switch,
    Button
  } = window.SolumDesignSystem_d48af3;
  const [day, setDay] = React.useState('Tomorrow');
  const [time, setTime] = React.useState('5pm');
  const [remind, setRemind] = React.useState(true);
  return /*#__PURE__*/React.createElement(SheetFrame, {
    title: 'Follow up · ' + stop.name,
    onClose: onClose,
    actions: /*#__PURE__*/React.createElement(Button, {
      variant: "signal",
      fullWidth: true,
      onClick: () => onSave(day, time)
    }, "Set follow-up")
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "solum-label",
    style: {
      color: 'var(--ink-muted)',
      marginBottom: 10
    }
  }, "When"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 8,
      flexWrap: 'wrap'
    }
  }, ['Today', 'Tomorrow', 'Next week', 'Pick date'].map(o => /*#__PURE__*/React.createElement(Chip, {
    key: o,
    selected: day === o,
    onClick: () => setDay(o)
  }, o))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 8,
      marginTop: 8
    }
  }, ['9am', '12pm', '5pm'].map(o => /*#__PURE__*/React.createElement(Chip, {
    key: o,
    selected: time === o,
    onClick: () => setTime(o)
  }, o)))), /*#__PURE__*/React.createElement(TextField, {
    label: "What to say",
    placeholder: "Bring the price sheet"
  }), /*#__PURE__*/React.createElement(Switch, {
    label: "Remind me that morning",
    checked: remind,
    onChange: setRemind
  }));
}
Object.assign(window, {
  SheetFrame,
  LogVisitSheet,
  FollowUpSheet
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/app/Sheets.jsx", error: String((e && e.message) || e) }); }

// ui_kits/app/data.js
try { (() => {
window.SOLUM_DATA = {
  user: 'Dana',
  area: {
    name: 'Westgate',
    visited: 29,
    total: 41
  },
  stops: [{
    id: 1,
    x: 118,
    y: 236,
    state: 'followup',
    name: 'Maria Lopez',
    address: '214 Alder St',
    note: 'Interested in a quote. Call after 5pm.',
    when: '4pm',
    phone: '(503) 555-0142'
  }, {
    id: 2,
    x: 252,
    y: 300,
    state: 'followup',
    name: 'Kessler Hardware',
    address: '90 Birch Ave',
    note: 'Owner back Thursday. Bring the price sheet.',
    when: '11am',
    phone: '(503) 555-0187'
  }, {
    id: 3,
    x: 300,
    y: 420,
    state: 'followup',
    name: 'Tom & Priya Nguyen',
    address: '38 Birch Ln',
    note: 'Asked for a second visit with both home.',
    when: '6pm',
    phone: '(503) 555-0110'
  }, {
    id: 4,
    x: 92,
    y: 330,
    state: 'visited',
    name: '220 Alder St',
    address: 'Visited Tue · left flyer'
  }, {
    id: 5,
    x: 150,
    y: 330,
    state: 'visited',
    name: '226 Alder St',
    address: 'Visited Tue · not home'
  }, {
    id: 6,
    x: 205,
    y: 236,
    state: 'visited',
    name: 'Alder Dental',
    address: 'Visited Mon · spoke to manager'
  }, {
    id: 7,
    x: 176,
    y: 420,
    state: 'visited',
    name: '12 Birch Ln',
    address: 'Visited Mon'
  }, {
    id: 8,
    x: 236,
    y: 420,
    state: 'unvisited',
    name: '24 Birch Ln',
    address: 'Not visited'
  }, {
    id: 9,
    x: 92,
    y: 420,
    state: 'unvisited',
    name: '4 Birch Ln',
    address: 'Not visited'
  }, {
    id: 10,
    x: 290,
    y: 236,
    state: 'unvisited',
    name: '240 Alder St',
    address: 'Not visited'
  }, {
    id: 11,
    x: 318,
    y: 330,
    state: 'visited',
    name: 'Corner Market',
    address: 'Visited Mon'
  }, {
    id: 12,
    x: 205,
    y: 510,
    state: 'unvisited',
    name: '7 Cedar Ct',
    address: 'Not visited'
  }]
};
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/app/data.js", error: String((e && e.message) || e) }); }

__ds_ns.Button = __ds_scope.Button;

__ds_ns.Icon = __ds_scope.Icon;

__ds_ns.IconButton = __ds_scope.IconButton;

__ds_ns.Logo = __ds_scope.Logo;

__ds_ns.ContactRow = __ds_scope.ContactRow;

__ds_ns.Badge = __ds_scope.Badge;

__ds_ns.ProgressBar = __ds_scope.ProgressBar;

__ds_ns.Toast = __ds_scope.Toast;

__ds_ns.Checkbox = __ds_scope.Checkbox;

__ds_ns.Chip = __ds_scope.Chip;

__ds_ns.Switch = __ds_scope.Switch;

__ds_ns.TextField = __ds_scope.TextField;

__ds_ns.AreaProgress = __ds_scope.AreaProgress;

__ds_ns.GreetingCard = __ds_scope.GreetingCard;

__ds_ns.MapPin = __ds_scope.MapPin;

__ds_ns.BottomSheet = __ds_scope.BottomSheet;

__ds_ns.Card = __ds_scope.Card;

})();
