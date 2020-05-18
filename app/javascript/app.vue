<template>
  <div id="vue-app">
    <navBar />
    <alert-message />
    <router-view />
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import navBar from 'components/navBar.vue';
import alertMessage from 'components/alerts/alertMessage.vue';

export default {
  name: 'App',
  components: {
    navBar,
    alertMessage,
  },
  methods: {
    ...mapActions('alert', ['clearAlert']),
  },
};
</script>
