# React - "jsxDEV is not a function" in production build

[⬅️ Symfony Starter documentation](../README.md)

---

## Problem

After building your assets for production (`encore production`), pages rendering a React component (e.g. via `@symfony/ux-react`) throw this error in the browser console:

> Uncaught TypeError: (0 , s.jsxDEV) is not a function

`jsxDEV` is used by React's automatic JSX runtime in **development** mode. Seeing it in a production bundle means Babel compiled your JSX as a dev build, while the shipped React runtime is production and doesn't implement `jsxDEV`.

Since Babel 8, `@babel/preset-react` defaults `runtime` to `"automatic"`, and whether it emits `jsx()` (prod) or `jsxDEV()` (dev) depends on Babel's `envName` (`BABEL_ENV || NODE_ENV || "development"`). `Encore.enableReactPreset()` doesn't let you pass a `development` option to the preset, so Babel falls back to its own `envName`, which can resolve to `"development"` even during an `encore production` build.

## Solution

In `webpack.config.js`, explicitly align `BABEL_ENV` with Encore's mode, **after** the `configureRuntimeEnvironment()` block (that block is skipped in normal usage, so anything inside it never runs):

```js
if (!Encore.isRuntimeEnvironmentConfigured()) {
  Encore.configureRuntimeEnvironment(process.env.NODE_ENV || 'dev');
}

// Explicitly align Babel's envName with Encore's mode, since enableReactPreset()
// doesn't let us pass options to @babel/preset-react (development/runtime).
process.env.BABEL_ENV = Encore.isProduction() ? 'production' : 'development';

Encore
  .setOutputPath('public/build/')
// ...
```

Then clear the Babel loader cache (in case a previous dev build left stale results) and rebuild:

```shell
# in /symfony-starter
make php_command a="rm -rf node_modules/.cache/babel-loader"
make npm_build
```

---

[⬅️ Symfony Starter documentation](../README.md)
