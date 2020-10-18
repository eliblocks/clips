import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    console.log("initializing uppy!!!!!!")
    const axios = require('axios');
    const Uppy = require('@uppy/core')
    const Dashboard = require('@uppy/dashboard')
    const AwsS3Multipart = require('@uppy/aws-s3-multipart')
    require('@uppy/core/dist/style.css')
    require('@uppy/dashboard/dist/style.css')


    const uppy = Uppy()
      .use(Dashboard, {
        trigger: '#select-files',
        proudlyDisplayPoweredByUppy: false,
      })
      .use(AwsS3Multipart, {
        limit: 10,
        companionUrl: '/'
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
          window.location.reload()
        })
        .catch(function (error) {
          console.log(error);
        });
      })
      console.log('Upload complete!', result)
    })
  }
}