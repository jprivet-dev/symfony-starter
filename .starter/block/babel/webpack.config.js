// Explicitly align Babel's envName with Encore's mode, since enableReactPreset()
// doesn't let us pass options to @babel/preset-react (development/runtime).
process.env.BABEL_ENV = Encore.isProduction() ? 'production' : 'development';
