<template>
  <div class="items-center h-screen w-full bg-primary p-12 mt-24 text-center">
    <text-field font-size="full">
      ¡Ya estas conectado con splitwise!
    </text-field>
    <text-field font-color="secondary">
      Cierra esta pestaña o dirigete a Bitsplit para continuar
    </text-field>
    <router-link to="/">
      <button class="btn p-2">
        Ir a Bitsplit
      </button>
    </router-link>
  </div>
</template>

<script>
import textField from '../components/TextField';

export default {
  name: 'Profile',
  components: {
    textField,
  },
};
</script>

<style lang="scss"></style>
