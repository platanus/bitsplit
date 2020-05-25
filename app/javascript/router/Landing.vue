<template>
  <SignIn />
</template>

<script>
import { mapGetters } from 'vuex';
import SignIn from './SignIn';

export default {
  name: 'Landing',
  data() {
    return {
      routeName: 'Landing',
    };
  },
  components: {
    SignIn,
  },
  computed: {
    ...mapGetters('user', ['signedIn']),
  },
};
</script>

<style lang="scss"></style>
