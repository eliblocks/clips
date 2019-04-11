/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

console.log('Hello World from Webpacker')

// require("@rails/activestorage").start()
// Import the plugins

// src/application.js
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("../src/controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

const axios = require('axios');
const Uppy = require('@uppy/core')
const XHRUpload = require('@uppy/xhr-upload')
const Dashboard = require('@uppy/dashboard')
const AwsS3Multipart = require('@uppy/aws-s3-multipart')
// And their styles (for UI plugins)
require('@uppy/core/dist/style.css')
require('@uppy/dashboard/dist/style.css')

const uppy = Uppy()
  .use(Dashboard, {
    trigger: '#select-files',
    proudlyDisplayPoweredByUppy: false,
  })
  .use(AwsS3Multipart, {
    limit: 10,
    serverUrl: '/'
  })

uppy.on('complete', (result) => {
  result.successful.map(video => {
    axios.post('/videos', {
      video: {
        title: video.name,
        storage_url: video.uploadURL
      }
    })
    .then(function (response) {
      console.log(response);
    })
    .catch(function (error) {
      console.log(error);
    });
  })
  console.log('Upload complete!', result)
})
