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
    ...mapState('user', ['budaProfileComp']),
  },
  methods: {
    ...mapActions('user', ['changeProfileComp']),
    ...mapGetters('user', ['budaSignedIn'])
  },
  created() {
    if (this.budaSignedIn()) {
      localStorage.setItem('currentComponent','budaIndex')
      this.changeProfileComp('budaIndex')
    }
    else {
      localStorage.setItem('currentComponent','budaForm')
      this.changeProfileComp('budaForm')
    }
  },
  beforeDestroy() {
    localStorage.setItem('currentComponent','budaIndex')
    this.changeProfileComp('budaIndex')
  },
}
</script>