<template>
  <div class="bg-primary items-center bg-auto w-full min-h-screen" id="vue-app">
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
