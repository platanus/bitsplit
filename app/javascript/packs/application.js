import Vue from 'vue/dist/vue.esm'

// import App from '../app.vue'
import store from './../store'
import router from './../router'

import '../css/application.css'

import App from './../app.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    router,
    store,
    el: '#vue-app',
    render: h => h(App)
  })

  return app
})
