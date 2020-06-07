const { join } = require('path');
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
    })
  ],
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
              presets: [['@babel/preset-env', {
                "targets": "> 5%",
              }], '@babel/react'],
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
