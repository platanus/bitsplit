<template>
  <div id="budaSignInForm">
    <center>
      <div class="w-full max-w-xs">
        <div>
          <p class="block text-gray-700 text-sm font-bold mb-5">¡Ya estás conectado a una cuenta Buda! ¿Qué desear hacer?</p>
        </div>
        <div class=inline>
          <div class="pb-6">
            <submitButton @do-click="change('BudaForm')" 
            classmod="bg-indigo-600 hover:bg-indigo-700 w-full" :fieldDisabled="false" fieldPlaceholder="Actualizar Keys" />
          </div>
          <div class="pb-6">
            <submitButton @do-click="change('BudaLogoutForm')" 
            classmod="bg-indigo-600 hover:bg-indigo-700 w-full" :fieldDisabled="false" fieldPlaceholder="Desconectar Buda" />
          </div>
        </div>
      </div>
    </center>
  </div>
</template>

<script>
import { mapActions, mapState, mapMutations } from 'vuex'
import textInput from '../components/Input.vue'
import passwordInput from '../components/PasswordInput'
import submitButton from '../components/SubmitButton'
import inputLabel from '../components/InputLabel'

export default {
  name: 'budaIndex',
  data() {
    return {
      routeName: 'budaIndex',
      api_key: '',
      api_secret: '',
      password: '',
    }
  },
  components: {
    textInput,
    passwordInput,
    submitButton,
    inputLabel
  },
  methods: {
    ...mapActions('component', ['changeProfileComp']),
    change(form) {
      this.changeProfileComp(form)
    }
  }
}
</script>

<style scoped>
#budaSignInForm {
  margin-top: 60px;
  margin-bottom: 60px;
}
</style>