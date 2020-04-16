<template>
  <div>
    <component :is="budaProfileComp"></component>
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
    ...mapState('component', ['budaProfileComp']),
  },
  methods: {
    ...mapActions('component', ['changeProfileComp']),
    ...mapGetters('user', ['budaSignedIn'])
  },
  created() {
    if (this.budaSignedIn()) {
      this.changeProfileComp('BudaIndex')
    }
    else {
      this.changeProfileComp('BudaForm')
    }
  }
}
</script>