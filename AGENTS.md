# AGENTS.md

## Projeto

Projeto: ESP32-DIV V2.1
Hardware alvo: ESP32-DIV V2/V2.1 com ESP32-S3
Diretório raiz: `/Users/baugusto/Projetos/esp32-div-v2.1/`
Sketch Arduino: `/Users/baugusto/Projetos/esp32-div-v2.1/ESP32-DIV/ESP32-DIV`

Ambiente padrão:

- VS Code como IDE
- Arduino CLI para compilação, upload e monitor serial
- Arduino IDE apenas como fallback
- Codex para análise e evolução faseada do código

Scripts principais:

- Compilar: `./ESP32-DIV/scripts/compile.sh`
- Upload: `./ESP32-DIV/scripts/upload.sh`
- Upload com erase total para recuperação/primeira gravação após troca de partição: `./ESP32-DIV/scripts/upload_erase.sh`
- Monitor serial: `./ESP32-DIV/scripts/monitor.sh`

## Hardware alvo

O projeto deve considerar como alvo principal:

- ESP32-S3
- 16 MB flash
- TFT ILI9341
- Touch XPT2046
- 4 LEDs RGB WS2812B
- Buzzer integrado
- 3 módulos NRF24L01
- 1 módulo CC1101 SubGHz
- Slot TF/SD
- Gerenciamento de energia com IP5306 ou circuito equivalente
- PN532 futuro, ainda não instalado
- GPS futuro, ainda não instalado

## Build/upload ESP32-DIV V2/V2.1

Para evitar o problema de tela branca reportado para ESP32-DIV V2/V2.1, os scripts Arduino CLI devem usar o alvo ESP32-S3 com:

- `FlashSize=16M`
- `FlashMode=dio`
- `PartitionScheme=app3M_fat9M_16MB`
- `UploadSpeed=115200`
- `CDCOnBoot=cdc` para logs de boot via USB serial

Referência externa: GitHub issue `cifertech/ESP32-DIV#159`, que recomenda ESP32-S3, modo DIO, SPI flash em 40 MHz, baud 115200 e offsets padrão `bootloader 0x0`, `partitions 0x8000`, `app 0x10000`. No Arduino ESP32 core 2.0.17 instalado, o bootloader ESP32-S3 `dio_40m` não existe; por isso os scripts usam DIO/115200 com o bootloader disponível do core.

Quando a placa ficar em tela branca após mudança de modo de flash ou partição, use uma vez:

```bash
./ESP32-DIV/scripts/upload_erase.sh
```

Depois volte ao upload normal:

```bash
./ESP32-DIV/scripts/upload.sh
```

## Restrições reais do ESP32-S3

O ESP32-S3 não suporta Wi-Fi 5 GHz.

O ESP32-S3 não suporta Bluetooth Classic.

Portanto:

- Não implementar suporte real a Wi-Fi 5 GHz.
- Não implementar Bluetooth Classic, SPP, A2DP ou descoberta Classic.
- BLE é suportado e deve ser preservado.
- Funcionalidades BLE como scan, advertising, HID/Ducky e spoofing BLE podem ser mantidas.
- Menus ou mensagens que indiquem Bluetooth Classic devem ser corrigidos, ocultados ou marcados como não suportados no ESP32-S3.

## Regras obrigatórias para o agente

1. Leia este arquivo antes de alterar qualquer código.
2. Não altere arquivos fora do repositório sem autorização explícita.
3. Não altere bibliotecas em `~/Documents/Arduino/libraries` sem pedir aprovação antes.
4. Faça mudanças pequenas, isoladas e por fase.
5. Não avance para a próxima fase sem validação humana.
6. Antes de editar código em cada fase, apresente o plano da fase e aguarde confirmação.
7. Depois de cada alteração, execute `./ESP32-DIV/scripts/compile.sh`.
8. Se a compilação falhar, pare, explique o erro, proponha correção e aguarde aprovação.
9. Não use `delay()` em caminhos de runtime para buzzer, LEDs, UI, Wi-Fi, BLE, RF, GPS ou SD.
10. Use lógica não bloqueante baseada em `millis()`.
11. Não remova funcionalidades existentes sem justificar.
12. Preserve compatibilidade com Arduino IDE e Arduino CLI.
13. Sempre mostre resumo dos arquivos alterados e o motivo de cada alteração.
14. Não faça refatorações grandes sem autorização.
15. Não misture várias fases em uma única alteração.
16. Não altere pinagem sem documentar o motivo.
17. Não assuma que PN532 ou GPS já estão instalados.
18. O firmware deve funcionar mesmo sem PN532 e sem GPS.
19. O firmware deve falhar de forma limpa quando periféricos não forem detectados.
20. Nunca usar `--force` para gravar imagem incompatível no ESP32-S3.

## Estado atual conhecido

O projeto já passou por ajustes para compilar no ESP32-S3, incluindo:

- Correção de include antigo da CC1101.
- Correções relacionadas ao core ESP32-S3.
- Uso do core `esp32:esp32 2.0.17`.
- Correção da biblioteca SmartRC-CC1101-Driver-Lib para evitar conflitos de símbolos.
- Desativação do driver duplicado `ELECHOUSE_CC1101_SRC_JT_DRV`.
- Renomeação do símbolo global `spi` da CC1101 para evitar conflito com `TFT_eSPI`.
- Atenção ao conflito `ieee80211_raw_frame_sanity_check` em `wifi.cpp` quando usando Arduino ESP32 core 2.0.17.

Antes de assumir qualquer estado, sempre rode:

```bash
git status
./ESP32-DIV/scripts/compile.sh
```

## Roadmap de evolução

### Fase 0 — Baseline e diagnóstico

Objetivo:
Mapear o estado atual do projeto sem alterar código.

Tarefas:

- Rodar `git status`.
- Rodar `./ESP32-DIV/scripts/compile.sh`.
- Localizar arquivos principais:
  - `ESP32-DIV.ino`
  - `shared.h`
  - `utils.cpp`
  - `wifi.cpp`
  - `bluetooth.cpp`
  - `subghz.cpp`
  - `rfid.cpp`
  - `SettingsStore.h`
  - `SettingsStore.cpp`

- Mapear usos de:
  - `BUZZER_PIN`
  - `neopixelEnabled`
  - `WS2812`
  - `NeoPixel`
  - `FastLED`
  - `Adafruit_NeoPixel`
  - `drawStatusBar`
  - `WifiScan::getLastCount`
  - `BleScan::getLastCount`
  - `BATTERY_ADC_PIN`
  - `PN532`
  - `GPS`
  - `NRF24`
  - `CC1101`

Entrega:

- Relatório de baseline.
- Estado do Git.
- Resultado da compilação.
- Arquivos relevantes encontrados.
- Mapa dos pontos de buzzer.
- Mapa dos pontos de NeoPixel/WS2812.
- Mapa da status bar.
- Riscos técnicos.
- Próximos passos sugeridos para a Fase 1.

Não alterar código nesta fase.

### Fase 1 — Mapa de hardware e pinos da V2.1

Objetivo:
Centralizar e documentar a pinagem real do ESP32-DIV V2.1.

Tarefas:

- Criar ou propor `BoardPins_ESP32DIV_V2.h`.
- Mapear conflitos conhecidos:
  - `BUZZER_PIN` definido como `-1`.
  - Comentário indicando buzzer em IO2.
  - PN532 ainda não instalado.
  - GPS ainda não instalado.
  - Possível conflito PN532 com NRF24 dependendo do CS.
  - Possível conflito GPS com NRF24 se usar GPIO 47/48.
  - Possível conflito IR com NRF24 #3 se usar GPIO 14/21.

- Separar hardware interno, externo e futuro.
- Não trocar todos os includes de uma vez.
- Não mudar comportamento funcional grande.

Entrega:

- Header ou documentação inicial de pinagem.
- Lista de conflitos.
- Build compilando.

### Fase 2 — BuzzerService

Objetivo:
Corrigir e estruturar o buzzer integrado.

Tarefas:

- Encontrar todos os usos do buzzer.
- Criar serviço não bloqueante:
  - `begin()`
  - `loop()`
  - `beepClick()`
  - `beepSuccess()`
  - `beepError()`
  - `beepCapture()`
  - `beepWarning()`

- Tratar pino inválido.
- Se `BUZZER_PIN` continuar `-1`, compilar e não tocar.
- Não assumir IO2 como definitivo sem documentar.
- Integrar inicialmente apenas em pontos seguros:
  - boot OK
  - erro
  - captura SubGHz já existente
  - ação de sucesso

Entrega:

- Serviço de buzzer.
- Eventos documentados.
- Build compilando.
- Plano de teste no hardware.

### Fase 3 — StatusLedService para 4 LEDs WS2812B

Objetivo:
Implementar suporte real aos 4 LEDs RGB WS2812B.

Tarefas:

- Verificar se já há biblioteca disponível:
  - `Adafruit_NeoPixel`
  - `FastLED`
  - `NeoPixelBus`

- Se não houver biblioteca, propor dependência antes de alterar.
- Criar serviço não bloqueante:
  - `begin()`
  - `loop()`
  - `setMode()`
  - `event()`
  - `off()`

- Respeitar `settings().neopixelEnabled`.
- Não espalhar `pixels.show()` pelo projeto.
- Criar padrões para:
  - boot
  - idle
  - Wi-Fi scan
  - BLE scan
  - SubGHz activity
  - NRF24 activity
  - SD error
  - capture success
  - battery low
  - GPS searching/fix no futuro

- Se o pino dos WS2812B não estiver confirmado, implementar pinagem configurável e documentar pendência.

Entrega:

- Serviço de LEDs.
- Integração mínima segura.
- Build compilando.
- Plano de teste dos 4 LEDs.

### Fase 4 — Barra de status real

Objetivo:
Fazer os ícones superiores refletirem estados reais do hardware.

Tarefas:

- Analisar `drawStatusBar` em `utils.cpp`.
- Mapear variáveis de:
  - Wi-Fi
  - BLE
  - sinal
  - SD
  - bateria
  - temperatura
  - GPS

- Separar quantidade de redes de estado real do Wi-Fi.
- Separar quantidade de dispositivos BLE de estado real do BLE.
- Criar estrutura leve de estado, por exemplo:
  - `HardwareStatus`
  - `SystemStatus`

- Estados sugeridos:
  - Wi-Fi: `off`, `scanning`, `active`, `error`, `portal`
  - BLE: `off`, `scanning`, `advertising`, `active`, `error`
  - SD: `missing`, `mounted`, `writing`, `error`
  - RF: `idle`, `scanning`, `detected`, `error`
  - GPS: `notInstalled`, `searching`, `fix`, `logging`
  - Battery: `unknown`, `usb`, `discharging`, `charging`, `low`

- Evitar redraw completo desnecessário.

Entrega:

- Barra de status com lógica clara.
- Build compilando.
- Documentação do significado de cada ícone.

### Fase 5 — Bateria e energia

Objetivo:
Corrigir indicação de bateria/status de energia.

Tarefas:

- Analisar `readBatteryVoltage`.
- Analisar `BATTERY_ADC_PIN`.
- Não chamar `analogRead()` em pino inválido.
- Usar `BATTERY_VDIV_R1` e `BATTERY_VDIV_R2` se aplicável.
- Deixar fallback `unknown` quando não houver ADC configurado.
- Investigar se existe suporte ao IP5306.
- Não implementar leitura IP5306 via I2C sem confirmar endereço e ligação.

Entrega:

- Leitura de bateria segura.
- Sem valores falsos quando pino não existir.
- Status bar coerente com informação disponível.
- Build compilando.

### Fase 6 — Limpeza de Wi-Fi 5 GHz e Bluetooth Classic

Objetivo:
Remover ou ocultar funcionalidades impossíveis no ESP32-S3.

Tarefas:

- Localizar textos, menus e funções que mencionem:
  - Wi-Fi 5 GHz
  - Bluetooth Classic
  - Classic BT Scan
  - SPP
  - A2DP
  - `esp_bt_gap_*`

- Não remover código agressivamente.
- Preferir:
  - desabilitar menu
  - mostrar “não suportado no ESP32-S3”
  - manter BLE funcional

- Garantir preservação de:
  - BLE Scanner
  - BLE advertising
  - BLE HID/Ducky
  - funções NimBLE

Entrega:

- Menus e mensagens coerentes com ESP32-S3.
- Build compilando.

### Fase 7 — Preparação para PN532 e GPS futuros

Objetivo:
Preparar o projeto para receber PN532 e GPS quando os módulos chegarem, sem quebrar o hardware atual.

Tarefas:

- Não assumir que PN532 e GPS já estão conectados.
- Criar flags ou perfis para:
  - PN532 não instalado
  - GPS não instalado
  - PN532 via SPI
  - GPS via UART

- Documentar conflitos de pino com NRF24/IR.
- Garantir boot normal sem PN532/GPS.
- Detecção automática deve falhar de forma limpa e sem travar.

Entrega:

- Projeto preparado para módulos futuros.
- Build compilando.
- Checklist de ligação física para validação posterior.

### Fase 8 — Consolidação e documentação

Objetivo:
Deixar o projeto pronto para evolução contínua.

Tarefas:

- Criar ou atualizar:
  - `docs/HARDWARE_V2_1.md`
  - `docs/STATUS_INDICATORS.md`
  - `docs/BUILD_VSCODE_ARDUINO_CLI.md`

- Documentar:
  - como compilar
  - como fazer upload
  - como abrir monitor serial
  - limitações do ESP32-S3
  - eventos do buzzer
  - padrões dos LEDs
  - ícones da barra superior
  - pendências PN532/GPS

Entrega:

- Documentação objetiva.
- Build final compilando.
- Resumo final das alterações.

## Formato de resposta esperado do agente

Sempre responder com:

1. Fase atual.
2. Plano antes de alterar.
3. Arquivos que pretende tocar.
4. Riscos.
5. Confirmação solicitada antes de editar.
6. Após autorização, executar alteração pequena.
7. Rodar compile.
8. Informar resultado.
9. Parar e aguardar validação humana.

## Comando inicial recomendado

Comece apenas pela Fase 0.

Não edite nenhum arquivo na primeira resposta.

Leia o projeto, rode os comandos necessários de inspeção e compile. Depois entregue o relatório da Fase 0 com:

- estado do git
- resultado do compile
- arquivos relevantes encontrados
- mapa dos pontos de buzzer
- mapa dos pontos de NeoPixel/WS2812
- mapa da status bar
- riscos técnicos
- sugestão de próximos passos para a Fase 1
