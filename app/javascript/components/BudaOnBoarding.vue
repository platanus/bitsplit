<template>
  <div>
    <component :is="budaComp" v-bind="{ onBoardingScreen: true }" />
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex';
import BudaForm from '../components/BudaForm';
import BudaLogoutForm from '../components/BudaLogoutForm';
import BudaIndex from '../components/BudaIndex';

export default {
  name: 'BudaProfile',
  data() {
    return {
      routeName: 'budaProfile',
    };
  },
  components: {
    BudaForm,
    BudaLogoutForm,
    BudaIndex,
  },
  computed: {
    ...mapState('component', ['budaComp']),
  },
  methods: {
    ...mapActions('component', ['changeBudaComp']),
    ...mapGetters('user', ['budaSignedIn']),
  },
  created() {
    if (this.budaSignedIn()) {
      this.changeBudaComp('BudaIndex');
    } else {
      this.changeBudaComp('BudaForm');
    }
  },
};
</script>
