<template>
  <div class="mt-16">
    <center>
      <div class="w-full max-w-xs">
        <div>
          <textField>¡Ya estás conectado a una cuenta Buda! ¿Qué desear hacer?"</textField>
        </div>
        <div class="inline">
          <div class="pb-6">
            <submitButton
              @do-click="change('BudaForm')"
              width="full"
              color="secondary"
              :fieldDisabled="false"
            >Actualizar Keys</submitButton>
          </div>
          <div class="pb-6">
            <submitButton
              @do-click="change('BudaLogoutForm')"
              width="full"
              color="secondary"
              :fieldDisabled="false"
            >Desconectar Buda</submitButton>
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
import textField from '../components/TextField'

export default {
  name: 'budaIndex',
  data() {
    return {
      routeName: 'budaIndex',
      api_key: '',
      api_secret: '',
      password: ''
    }
  },
  components: {
    textInput,
    passwordInput,
    submitButton,
    inputLabel,
    textField
  },
  methods: {
    ...mapActions('component', ['changeBudaComp']),
    change(form) {
      this.changeBudaComp(form)
    }
  }
}
</script>