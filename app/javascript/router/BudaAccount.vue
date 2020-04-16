<template>
  <div>
    <component :is="budaPerfilComp"></component>
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex'
import BudaForm from '../components/BudaForm'
import BudaLogoutForm from '../components/BudaLogoutForm'
import BudaPerfil from '../components/BudaPerfil'

export default {
  name: 'BudaAccount',
  data() {
    return {
      routeName: 'BudaAccount',
    }
  },
  components: {
    BudaForm,
    BudaLogoutForm,
    BudaPerfil
  },
  computed: {
    ...mapState('user', ['budaPerfilComp']),
  },
  methods: {
    ...mapActions('user', ['changePerfilComp']),
    ...mapGetters('user', ['budaSignedIn'])
  },
  created() {
    if (this.budaSignedIn()) {
      localStorage.setItem('currentComponent','budaPerfil')
      this.changePerfilComp('budaPerfil')
    }
    else {
      localStorage.setItem('currentComponent','budaForm')
      this.changePerfilComp('budaForm')
    }
  },
  beforeDestroy() {
    localStorage.setItem('currentComponent','budaPerfil')
    this.changePerfilComp('budaPerfil')
  },
}
</script>