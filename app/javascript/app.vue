<template>
  <div id="vue-app">
    <header></header>
    <div v-if="alert.message" :class="`alert ${alert.type}`">
      {{ alert.message }}
    </div>
    <router-view></router-view>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'

import navBar from './components/navBar.vue'
import alertMessage from './components/alertMessage.vue'

export default {
  name: 'app',

  components: {
    navBar,
    alertMessage
  },
  methods: {
    ...mapActions('alert', ['clear_alert'])
  },

  watch: {
    $route(to, from) {
      // clear alert on location change
      this.clear_alert()
    }
  }
}
</script>
