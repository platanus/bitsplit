<template>
  <span>
    <button
      v-if="!confirmed"
      @click.prevent="confirm"
      class="btn ext-black font-bold p-2 rounded focus:outline-none"
      :class="[
        width === 'full' ? 'w-full' : 'w-normal',
        !loading
          ? color === 'secondary'
            ? 'bg-indigo-500 hover:bg-indigo-700'
            : ''
          : color === 'secondary'
          ? 'bg-indigo-200 cursor-not-allowed'
          : 'cursor-not-allowed',
      ]"
      :disabled="loading"
    >
      Usuario no registrado, ¿Continuar?
    </button>

    <button
      v-else
      @click.once="$emit('do-click')"
      class="btn ext-black font-bold p-2 rounded focus:outline-none"
      :class="[
        width === 'full' ? 'w-full' : 'w-normal',
        !loading
          ? color === 'secondary'
            ? 'bg-indigo-500 hover:bg-indigo-700'
            : ''
          : color === 'secondary'
          ? 'bg-indigo-200 cursor-not-allowed'
          : 'cursor-not-allowed',
      ]"
      :disabled="loading"
    >
      <slot />
    </button>
  </span>
</template>

<script>
export default {
  name: 'SubmitButton',
  data() {
    return {
      // Cuando no este confirmado, se muestra version que dice que usuario no tiene mail
      confirmed: false,
    };
  },
  methods: {
    confirm() {
      console.log('confirm');
      this.confirmed = true;
    },
  },
  props: {
    fieldDisabled: Boolean,
    fieldPlaceholder: String,
    color: String,
    width: String,
    email: String,
    loading: {
      type: Boolean,
      default: false,
    },
  },
  watch: {
    email: {
      handler() {
        this.confirmed = false;
      },
    },
  },
};
</script>
