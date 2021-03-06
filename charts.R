#' Pie charts of projects by budget
#'
#' draw the chart by budget bucket
#'
#' @param table
#'
#' @return a highchart
#' @export
#'
#' @examples
#' plot_tranchebudget(table = table_panorama)
#'
plot_tranchebudget <- function(table) {
  gb_tranche <- table %>%
    dplyr::group_by(cout_estime_par_tranche) %>%
     dplyr::summarise(
      n = n()
      )
  gb_tranche <- gb_tranche[c(1,5,3,4,2,6), ]
  gb_tranche$cout_estime_par_tranche[gb_tranche$cout_estime_par_tranche == "< 5M€"] <- "Inf 5M€"


  hc_tranche <- highcharter::highchart() %>%
  highcharter::hc_add_series_labels_values(
  gb_tranche$cout_estime_par_tranche,
  gb_tranche$n,
  name = "Nombre de projets",
  colorByPoint = TRUE,
  type = "pie",
  colors = palette_budget())

  return(hc_tranche)
  }

#' Bar chart by phase
#'
#' @param table a data frame
#'
#' @return a hichchart
#' @export
#'
#' @examples
#' plot_phase(table = table_panorama)

plot_phase <- function(table) {
  gb_phase <- table %>%
    dplyr::group_by(ministere_nom_complet, phase_du_projet_en_cours) %>%
    dplyr::summarise(
      n = n()
      ) %>%
    dplyr::filter(is.na(phase_du_projet_en_cours) == FALSE) %>%
    tidyr::spread(phase_du_projet_en_cours, n, fill = 0)

  hc_phase <- highcharter::highchart() %>%
    highcharter::hc_chart(type = "bar") %>%
    highcharter::hc_xAxis(categories = gb_phase$ministere_nom_complet) %>%
#Ajout projets terminés
    highcharter::hc_add_series(
      name = "Terminé",
      data = gb_phase$"Terminé",
      color = palette_phase()[5]
    ) %>%
    highcharter::hc_add_series(
      name = "Déploiement",
      data = gb_phase$"Déploiement",
      color = palette_phase()[4]
    ) %>%
    highcharter::hc_add_series(
      name = "Expérimentation",
      data = gb_phase$'Expérimentation',
      color = palette_phase()[3]
    ) %>%
    highcharter::hc_add_series(
      name = "Conception / Réalisation",
      data = gb_phase$'Conception / Réalisation',
      color = palette_phase()[2]
    ) %>%
    highcharter::hc_add_series(
      name = "Cadrage",
      data = gb_phase$'Cadrage',
      color = palette_phase()[1]
    ) %>%
    highcharter::hc_plotOptions(
      series = list(stacking="normal")
    ) %>%
    highcharter::hc_legend(reversed = TRUE)

  return(hc_phase)
  }


#' Bar chart by budget
#'
#' @param table a data frame
#'
#' @return a highchart
#' @export
#'
#' @examples
#' plot_budget(table = table_panorama)

plot_budget <- function(table) {
  gb_budget <- table %>%
    dplyr::group_by(ministere_nom_complet, cout_estime_par_tranche) %>%
    dplyr::summarise(n = n()) %>%
    tidyr::spread(cout_estime_par_tranche, n, fill = 0)

  hc_budget <- highcharter::highchart() %>%
    highcharter::hc_chart(type = "bar") %>%
    highcharter::hc_xAxis(categories = gb_budget$ministere_nom_complet) %>%
    highcharter::hc_add_series(
      name = "plus de 100 M€",
      data = gb_budget$'plus de 100 M€',
      color = palette_budget()[6]
    ) %>%
    highcharter::hc_add_series(
      name = "entre 20 et 100 M€",
      data = gb_budget$'entre 20 et 100 M€',
      color = palette_budget()[5]
    ) %>%
    highcharter::hc_add_series(
      name = "entre 9 et 20 M€",
      data = gb_budget$'entre 9 et 20 M€',
      color = palette_budget()[4]
    ) %>%
    highcharter::hc_add_series(
      name = "entre 5 et 9 M€",
      data = gb_budget$'entre 5 et 9 M€',
      color = palette_budget()[3]
    ) %>%
    highcharter::hc_add_series(
      name = "moins de 5 M€",
      data = gb_budget$'moins de 5M€',
      color = palette_budget()[2]
    ) %>%
    highcharter::hc_add_series(
      name = "en cadrage",
      data = gb_budget$'en cadrage',
      color = palette_budget()[1]
    ) %>%
    highcharter::hc_plotOptions(
      series = list(stacking="normal")
    ) %>%
    highcharter::hc_legend(reversed = TRUE)

  return(hc_budget)
  }

#' Bar chart by zone
#'
#' @param table a data frame
#'
#' @return a highchart
#' @export
#'
#' @examples
#' plot_zone(table = table_panorama)

plot_zone <- function(table) {

  gb_zone <- table %>%
    dplyr::group_by(zone_fonctionnelle) %>%
    dplyr::summarise(n = n()) %>%
    dplyr::filter(is.na(zone_fonctionnelle) == FALSE)

  hc_zone <- highcharter::highchart() %>%
    highcharter::hc_add_series(
      name = "Nombre de projets",
      data = gb_zone,
      type = "bar",
      mapping = highcharter::hcaes(x = zone_fonctionnelle, y = n)
    ) %>%
    highcharter::hc_xAxis(categories = gb_zone$zone_fonctionnelle) %>%
    highcharter::hc_legend(enabled = FALSE)

  return(hc_zone)
  }

