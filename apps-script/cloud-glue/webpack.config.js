const { join } = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: [join(__dirname, 'src/index.js')],
  output: {
    path: join(__dirname, 'dist'),
    filename: 'sidebar.js',
  },
  plugins: [
    new HtmlWebpackPlugin({
      hash: false,
      filename: 'sidebar.html',
      template: join(__dirname, 'src', 'index.html'),
    }),

  ],
  externals: {
    "react": "React",
    "react-dom": "ReactDOM"
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        include: join(__dirname, 'src'),
        use: [
          {
            loader: 'babel-loader',
            options: {
              babelrc: false,
              presets: ['@babel/preset-env', '@babel/react'],
            },
          },
        ],
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      },
    ],
  },
};
