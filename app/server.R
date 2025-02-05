

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    #some data manipulation to derive the values of KPI boxes
    
    totalEmission <- sum(transmissionWiseEmission$totalCo2PerKm)
    sales.account <- transmissionWiseEmission[1,]
    prof.prod <- engineSizeWiseEmission[1,]
    #creating the valueBoxOutput content
    output$value1 <- semantic.dashboard::render_value_box({
        semantic.dashboard::value_box(
            value = formatC(sales.account$totalCo2PerKm, format="d", big.mark=','),
            subtitle = paste('Top Emission(Kg/km) Manufacturer:', sales.account$manufacturer),
            icon = icon("bar chart"),
            color = "purple",
            width = 5)
    })
    output$value2 <- semantic.dashboard::render_value_box({
        semantic.dashboard::value_box(
            value = formatC(totalEmission, format = "d", big.mark = ','),
            subtitle = 'Total Emission(kg/km)',
            icon = icon("line chart"),
            color = "green",
            width = 5)
    })
    output$value3 <- semantic.dashboard::render_value_box({
        semantic.dashboard::value_box(
            value = formatC(prof.prod$totalCo2PerKm, format = "d", big.mark = ','),
            subtitle = paste('Top Emission(kg/km) Engine Size(cm3):', prof.prod$engine_size_cm3),
            icon = icon("bar chart"),
            color = "blue",
            width = 5)
    })
    #creating the plotOutput content
    output$revenuebyPrd <- renderPlot({
        ggplot(data = data.frame(head(transmissionWiseEmission,10),stringsAsFactors = F) %>% ungroup(),
               aes( x= manufacturer, y = totalCo2PerKm, fill = factor(model))) +
            scale_fill_manual(values = as.vector(semantic_palette)) +
            geom_bar(position = "dodge", stat = "identity") + ylab(" (Emission in kg/km)") +
            xlab("Manufacturer") + theme(legend.position="bottom",
                                    plot.title = element_text(size = 15, face = "bold"),
                                    axis.text.x = element_text(angle = 90)) +
            ggtitle("Emission by Manufacturer") +
            labs(fill = "Model")
    })
    output$revenuebyRegion <- renderPlot({
        ggplot(data = data.frame(head(engineSizeWiseEmission,10),stringsAsFactors = F) %>% ungroup(),
               aes(x = manufacturer, y = totalCo2PerKm, fill = factor(fuel))) +
            scale_fill_manual(values = as.vector(semantic_palette)) +
            geom_bar(position = "dodge", stat = "identity") + ylab("Emission in kg/km") +
            xlab("Account") + theme(legend.position="bottom",
                                    plot.title = element_text(size = 15, face = "bold"),
                                    axis.text.x = element_text(angle = 90)) +
            ggtitle("Emission by Manufacturer") + labs(fill = "Fuel Type")
    })
    
})
