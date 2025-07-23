#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_system.h"
#include "esp_log.h"

static const char *TAG = "HELLO_WORLD";

void app_main(void)
{
    int counter = 0;
    
    ESP_LOGI(TAG, "ESP32 Docker QEMU Demo Starting...");
    
    while (1) {
        ESP_LOGI(TAG, "Hello World! Counter: %d", counter++);
        
        if (counter % 10 == 0) {
            ESP_LOGI(TAG, "System uptime: %d seconds", (int)(esp_timer_get_time() / 1000000));
        }
        
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}
