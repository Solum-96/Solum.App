/** Solum Tailwind preset. Import solum.css once, then: presets: [require('./tailwind.preset.js')] */
module.exports = {
  theme: {
    extend: {
      colors: {
        'surface': 'var(--surface)',
        'surface-raised': 'var(--surface-raised)',
        'sandstone': 'var(--sandstone)',
        'ink': 'var(--ink)',
        'ink-muted': 'var(--ink-muted)',
        'olive': 'var(--olive)',
        'on-olive': 'var(--on-olive)',
        'sol': 'var(--sol)',
        'on-sol': 'var(--on-sol)',
        'sol-tint': 'var(--sol-tint)',
        'basalt': 'var(--basalt)',
        'on-basalt': 'var(--on-basalt)'
      },
      fontFamily: { sans: ['"Plus Jakarta Sans"', 'system-ui', 'sans-serif'] },
      borderRadius: { sm: '10px', md: '16px', lg: '24px', pill: '999px' },
      spacing: { 'touch': '44px', 'button': '54px' },
      fontSize: {
        'display': ['56px', { lineHeight: '56px', fontWeight: '800' }],
        'title': ['26px', { lineHeight: '32px', fontWeight: '800' }],
        'heading': ['20px', { lineHeight: '26px', fontWeight: '700' }],
        'body-strong': ['16px', { lineHeight: '22px', fontWeight: '700' }],
        'body': ['16px', { lineHeight: '24px', fontWeight: '400' }],
        'small': ['14px', { lineHeight: '20px', fontWeight: '500' }],
        'label': ['13px', { lineHeight: '16px', fontWeight: '700' }]
      },
    },
  },
};
