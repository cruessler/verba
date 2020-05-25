const path = require('path');
const webpack = require('webpack');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new TerserPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({}),
    ],
  },
  entry: './app/assets/javascripts/application.js',
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, 'public/assets/'),
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
        },
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader'],
      },
      {
        test: /\.scss$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          {
            loader: 'sass-loader',
            options: {
              includePaths: ['node_modules/bootstrap-sass/assets/stylesheets/'],
            },
          },
        ],
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/],
        loader: 'elm-webpack-loader',
      },
      {
        test: /\.woff2?$|\.ttf$|\.eot$|\.svg$/,
        use: {
          loader: 'url-loader',
        },
      },
    ],
    noParse: [/\.elm$/],
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: 'app.css' }),
    new CopyWebpackPlugin([{ from: 'app/assets/images', to: '' }]),
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
    }),
  ],
});
