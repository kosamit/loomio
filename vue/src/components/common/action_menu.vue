<script lang="coffee">
import { some } from 'lodash-es'
export default
  props:
    actions: Object

  computed:
    canPerformAny: ->
      some @actions, (action) -> action.canPerform()

</script>

<template lang="pug">
.action-menu.lmo-no-print(v-if='canPerformAny')
  v-menu(offset-y)
    template(v-slot:activator="{ on, attrs }" )
      v-btn(:aria-label="$t('action_dock.more_actions')" icon small v-on="on" v-bind="attrs" @click.prevent)
        v-icon mdi-dots-horizontal
    v-list
      v-list-item(v-for="(action, name) in actions" :key="name" @click="action.perform()" v-if='action.canPerform()' :class="'action-dock__button--' + name")
        v-list-item-title(v-t="{path: (action.name || 'action_dock.'+name), args: (action.nameArgs && action.nameArgs()) }")
</template>
