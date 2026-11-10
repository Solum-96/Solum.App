// Solum theme for React / React Native. Generated from tokens.json
export const colors = {
  light: {
    surface: '#FAF8F3',
    surfaceRaised: '#FFFFFF',
    sandstone: '#E7DFD0',
    ink: '#1F2421',
    inkMuted: '#50564F',
    olive: '#4D5B2E',
    onOlive: '#FFFFFF',
    sol: '#E9B949',
    onSol: '#1F2421',
    solTint: '#FBF0D3',
    basalt: '#1F2421',
    onBasalt: '#FFFFFF',
  },
  dark: {
    surface: '#171A18',
    surfaceRaised: '#222623',
    sandstone: '#3A3E38',
    ink: '#F3F0E8',
    inkMuted: '#B9BDB6',
    olive: '#A3B57A',
    onOlive: '#171A18',
    sol: '#E9B949',
    onSol: '#1F2421',
    solTint: '#3D3420',
    basalt: '#1F2421',
    onBasalt: '#FFFFFF',
  },
} as const;

export const space = { 1: 4, 2: 8, 4: 16, 5: 20, 8: 32 } as const;
export const radius = { sm: 10, md: 16, lg: 24, pill: 999 } as const;
export const size = { touchMin: 44, buttonHeight: 54 } as const;

export const fontFamily = { regular: 'PlusJakartaSans-Regular', medium: 'PlusJakartaSans-Medium', bold: 'PlusJakartaSans-Bold', extraBold: 'PlusJakartaSans-ExtraBold' } as const;
export const text = {
  display: { fontFamily: fontFamily.extraBold, fontSize: 56, lineHeight: 56 },
  title: { fontFamily: fontFamily.extraBold, fontSize: 26, lineHeight: 32 },
  heading: { fontFamily: fontFamily.bold, fontSize: 20, lineHeight: 26 },
  bodyStrong: { fontFamily: fontFamily.bold, fontSize: 16, lineHeight: 22 },
  body: { fontFamily: fontFamily.regular, fontSize: 16, lineHeight: 24 },
  small: { fontFamily: fontFamily.medium, fontSize: 14, lineHeight: 20 },
  label: { fontFamily: fontFamily.bold, fontSize: 13, lineHeight: 16 },
} as const;
