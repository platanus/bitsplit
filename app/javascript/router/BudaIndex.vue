<template>
  <div>
    <component :is="budaComp"></component>
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex'
import BudaForm from '../components/BudaForm'
import BudaLogoutForm from '../components/BudaLogoutForm'
import BudaIndex from '../components/BudaIndex'

export default {
  name: 'budaProfile',
  data() {
    return {
      routeName: 'budaProfile',
    }
  },
  components: {
    BudaForm,
    BudaLogoutForm,
    BudaIndex
  },
  computed: {
    ...mapState('component', ['budaComp']),
  },
  methods: {
    ...mapActions('component', ['changeBudaComp']),
    ...mapGetters('user', ['budaSignedIn'])
  },
  created() {
    if (this.budaSignedIn()) {
      this.changeBudaComp('BudaIndex')
    }
    else {
      this.changeBudaComp('BudaForm')
    }
  }
}
</script>