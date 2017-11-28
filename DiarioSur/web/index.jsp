<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.util.List"%>
<%@page import="util.Properties"%>
<%@page import="ws.*"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String user = request.getParameter(Properties.USER_SELECTED);
    if (user != null) {
        user = URLDecoder.decode(user, "UTF-8");
        session.setAttribute(Properties.USER_SELECTED, user);
    } else if (session.getAttribute(Properties.USER_SELECTED) == null) {
        session.setAttribute(Properties.USER_SELECTED, user = Properties.USER_GUEST);
    } else {
        user = (String) session.getAttribute(Properties.USER_SELECTED);
    }

    List<Event> events = null;
    try {
        EventWS_Service eventService = new EventWS_Service();
        EventWS eventPort = eventService.getEventWSPort();
        events = eventPort.findAllEvents();
    } catch (Exception ex) {
        System.err.println("Error getting events from service");
        ex.printStackTrace();
    }

    List<Category> categories = null;
    try {
        CategoryWS_Service categoryService = new CategoryWS_Service();
        CategoryWS categoryPort = categoryService.getCategoryWSPort();
        categories = categoryPort.findAllCategories();
    } catch (Exception ex) {
        System.err.println("Error getting categories from service");
        ex.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Agenda - Diario Sur</title>
        <link rel="icon" href="//static1.diariosur.es/squido/latest/assets/icons/diario-sur/favicon.ico"/>
        <link rel="shortcut icon" href="//static1.diariosur.es/squido/latest/assets/icons/diario-sur/favicon.ico" type="image/x-icon"/>
        <link rel="apple-touch-icon" sizes="57x57" href="//static.diariosur.es/squido/latest/assets/icons/diario-sur/apple-touch-icon-57x57.png">
        <link rel="apple-touch-icon" sizes="60x60" href="//static1.diariosur.es/squido/latest/assets/icons/diario-sur/apple-touch-icon-60x60.png">
        <link rel="apple-touch-icon" sizes="72x72" href="//static1.diariosur.es/squido/latest/assets/icons/diario-sur/apple-touch-icon-72x72.png">
        <link rel="apple-touch-icon" sizes="76x76" href="//static3.diariosur.es/squido/latest/assets/icons/diario-sur/apple-touch-icon-76x76.png">
        <link rel="apple-touch-icon" sizes="114x114" href="//static.diariosur.es/squido/latest/assets/icons/diario-sur/apple-touch-icon-114x114.png">
        <link rel="apple-touch-icon" sizes="120x120" href="//static3.diariosur.es/squido/latest/assets/icons/diario-sur/apple-touch-icon-120x120.png">
        <link rel="apple-touch-icon" sizes="144x144" href="//static1.diariosur.es/squido/latest/assets/icons/diario-sur/apple-touch-icon-144x144.png">
        <link rel="apple-touch-icon" sizes="152x152" href="//static2.diariosur.es/squido/latest/assets/icons/diario-sur/apple-touch-icon-152x152.png">
        <link rel="apple-touch-icon" sizes="180x180" href="//static1.diariosur.es/squido/latest/assets/icons/diario-sur/apple-touch-icon-180x180.png">
        <link rel="icon" type="image/png" href="//static3.diariosur.es/squido/latest/assets/icons/diario-sur/favicon-16x16.png" sizes="16x16">
        <link rel="icon" type="image/png" href="//static.diariosur.es/squido/latest/assets/icons/diario-sur/favicon-32x32.png" sizes="32x32">
        <link rel="icon" type="image/png" href="//static1.diariosur.es/squido/latest/assets/icons/diario-sur/favicon-96x96.png" sizes="96x96">
        <link rel="icon" type="image/png" href="//static3.diariosur.es/squido/latest/assets/icons/diario-sur/android-chrome-192x192.png" sizes="192x192">
        <meta name="msapplication-square70x70logo" content="//static2.diariosur.es/squido/latest/assets/icons/diario-sur/smalltile.png"/>
        <meta name="msapplication-square150x150logo" content="//static2.diariosur.es/squido/latest/assets/icons/diario-sur/mediumtile.png"/>
        <meta name="msapplication-wide310x150logo" content="//static.diariosur.es/squido/latest/assets/icons/diario-sur/widetile.png"/>
        <meta name="msapplication-square310x310logo" content="//static2.diariosur.es/squido/latest/assets/icons/diario-sur/largetile.png"/>

        <link rel="stylesheet" href="https://bootswatch.com/4/darkly/bootstrap.min.css">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link rel="stylesheet" href="css/animate.css">
        <link rel="stylesheet" href="css/daterangepicker.css">
        <link rel="stylesheet" href="css/app.css">
    </head>
    <body>
        <nav class="navbar navbar-dark bg-warning navbar-expand-lg sticky-top">
            <div class="container">
                <a class="navbar-brand" href="/DiarioSur/">
                    <img src="img/logo.png" height="30" class="d-inline-block align-top" alt="logo">
                    <span class="text-secondary" style="margin-left: 16px;">Agenda</span>
                </a>

                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Expandir navegación">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarContent">
                    <ul class="navbar-nav mr-auto">
                        <li class="nav-item active">
                            <!-- a class="nav-link text-secondary" href="#">Home <span class="sr-only">(current)</span></a -->
                        </li>
                    </ul>
                    <ul class="navbar-nav">
                        <li class="nav-item dropdown">
                            <button class="btn btn-secondary nav-link dropdown-toggle px-2" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                Cambiar Usuario
                            </button>
                            <div class="dropdown-menu" aria-labelledby="userDropdown">
                                <a class="dropdown-item" href="index.jsp?<%= Properties.USER_SELECTED%>=<%= Properties.USER_GUEST%>">Invitado</a>
                                <a class="dropdown-item" href="index.jsp?<%= Properties.USER_SELECTED%>=<%= URLEncoder.encode(Properties.USER_USER, "UTF-8")%>">Usuario</a>
                                <a class="dropdown-item" href="index.jsp?<%= Properties.USER_SELECTED%>=<%= URLEncoder.encode(Properties.USER_SUPER, "UTF-8")%>">SuperUsuario</a>
                                <a class="dropdown-item" href="index.jsp?<%= Properties.USER_SELECTED%>=<%= URLEncoder.encode(Properties.USER_EDITOR, "UTF-8")%>">Redactor</a>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mt-4">
            <div class="jumbotron pt-4">
                <h1 class="display-4">¡Bienvenido!</h1>
                <p class="lead">This is a simple hero unit, a simple jumbotron-style component for calling extra attention to featured content or information.</p>
                <hr class="my-4">
                <p>It uses utility classes for typography and spacing to space content out within the larger container.</p>
                <p class="lead float-right">
                    <a class="btn btn-warning btn-lg" href="createEvent.jsp" role="button">Crear evento</a>
                </p>
            </div>

            <div class="row">
                <div class="col-lg-3 mb-4">
                    <h1>Filtritoh</h1>
                    <form>
                        <button type="submit" class="btn btn-warning">Filtrar</button>
                    </form>
                </div>

                <div class="col-lg-9">
                    <div class="card-columns">
                        <%
                            for (int i = 0; events != null && i < events.size(); i++) {
                                Event e = events.get(i);
                                if (user.equals(e.getAuthor().getEmail()) || e.getApproved() == 1 || user.equals(Properties.USER_EDITOR)) {
                        %>
                        <div class="card <% if (e.getApproved() == 0 && user.equals(Properties.USER_EDITOR)) { %>border-danger<% } else { %>border-dark<% }%> wow zoomIn" data-wow-delay="0.5s">
                            <img class="card-img-top rounded" src="<%= e.getImage()%>" alt="<%= e.getName()%>" data-toggle="modal" data-target="#eventModal<%= e.getId()%>" style="cursor: pointer;">
                            <div class="card-body">
                                <h4 class="card-title"><%= e.getName()%></h4>
                                <p class="card-text"><%= e.getDescription()%></p>
                                <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#eventModal<%= e.getId()%>">
                                    Ver evento
                                </button>
                            </div>
                        </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <%
            for (int i = 0; events != null && i < events.size(); i++) {
                Event e = events.get(i);
                if (user.equals(e.getAuthor().getEmail()) || e.getApproved() == 1 || user.equals(Properties.USER_EDITOR)) {
        %>
        <div class="modal fade" id="eventModal<%= e.getId()%>" tabindex="-1" role="dialog" aria-labelledby="eventModal<%= e.getId()%>Label" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title display-4 ml-auto" id="eventModal<%= e.getId()%>Label"><%= e.getName()%></h1>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span class="display-4" aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <nav class="nav nav-tabs nav-fill" id="eventModalTab<%= e.getId()%>" role="tablist">
                            <a class="nav-item nav-link active" id="nav-info-tab<%= e.getId()%>" data-toggle="tab" href="#nav-info<%= e.getId()%>" role="tab" aria-controls="nav-info<%= e.getId()%>" aria-selected="true">Info</a>
                            <%
                                if (user.equals(e.getAuthor().getEmail())) {
                            %>
                            <a class="nav-item nav-link" id="nav-edit-tab<%= e.getId()%>" data-toggle="tab" href="#nav-edit<%= e.getId()%>" role="tab" aria-controls="nav-edit<%= e.getId()%>" aria-selected="false">Editar</a>
                            <%
                                }
                            %>
                        </nav>
                        <div class="tab-content mt-4" id="nav-tabContent<%= e.getId()%>">
                            <div class="tab-pane fade show active" id="nav-info<%= e.getId()%>" role="tabpanel" aria-labelledby="nav-info-tab<%= e.getId()%>">
                                <div class="row">
                                    <div class="col-4">
                                        <img class="img-fluid rounded" src="<%= e.getImage()%>">
                                    </div>
                                    <div class="col-8">
                                        <p><%= e.getDescription()%></p>
                                    </div>
                                </div>
                                <div class="row mt-4">
                                    <table class="table table-hover">
                                        <tbody>
                                            <tr>
                                                <th class="text-right" scope="row">Autor</th>
                                                <td><%= e.getAuthor().getEmail()%></td>
                                            </tr>
                                            <tr>
                                                <th class="text-right" scope="row">Fecha de inicio</th>
                                                <td><%= e.getStartDate()%></td>
                                            </tr>
                                            <tr>
                                                <th class="text-right" scope="row">Fecha de clausura</th>
                                                <td><%= e.getEndDate()%></td>
                                            </tr>
                                            <tr>
                                                <th class="text-right" scope="row">Precio</th>
                                                <td><%= e.getPrice()%>&euro;</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="row mt-4">
                                    <div class="col-12">
                                        <%
                                            StringTokenizer st = new StringTokenizer(e.getAddress());
                                            String gmaps = "https://www.google.com/maps/embed/v1/place?key=AIzaSyBvwu9R5x0YwukwkoaynDNNKVR2z2RH6p4&q=";

                                            while (st.hasMoreTokens()) {
                                                gmaps += st.nextToken();
                                                if (st.hasMoreTokens())
                                                    gmaps += "+";
                                            }
                                        %>
                                        <iframe width="100%" height="450" frameborder="0" style="border: 0;" src="<%= gmaps%>" allowfullscreen></iframe>
                                    </div>
                                </div>
                                <hr>
                                <center>
                                    <%
                                        if (e.getApproved() == 0 && user.equals(Properties.USER_EDITOR)) {
                                    %>
                                    <span class="btn-group mr-4" role="group" aria-label="Basic example">
                                        <button type="button" class="btn btn-warning">Aceptar</button>
                                        <button type="button" class="btn btn-warning">Rechazar</button>
                                    </span>
                                    <%
                                        }
                                    %>
                                    <a class="btn btn-warning" href="<%= e.getShopUrl()%>">Comprar entradas</a>
                                    <!-- button type="button" class="btn btn-secondary" data-dismiss="modal">Editar evento</button -->
                                </center>
                            </div>
                            <%
                                if (user.equals(e.getAuthor().getEmail())) {
                            %>
                            <div class="tab-pane fade" id="nav-edit<%= e.getId()%>" role="tabpanel" aria-labelledby="nav-edit-tab<%= e.getId()%>">
                                <form>
                                    <div class="form-group">
                                        <label for="nameInput<%= e.getId()%>">Nombre</label>
                                        <input type="text" class="form-control" id="nameInput<%= e.getId()%>" placeholder="Nombre">
                                    </div>
                                    <div class="form-group">
                                        <label for="imgInput<%= e.getId()%>">Imagen</label>
                                        <input type="url" class="form-control" id="imgInput<%= e.getId()%>" aria-describedby="imgHelp<%= e.getId()%>" placeholder="URL de la imagen">
                                        <small id="imgHelp<%= e.getId()%>" class="form-text text-muted">Ha de ser una URL a una imagen PNG o JPG. Preferiblemente de 500x500px.</small>
                                    </div>
                                    <div class="form-group">
                                        <label for="addressInput<%= e.getId()%>">Dirección</label>
                                        <input type="text" class="form-control" id="addressInput<%= e.getId()%>" aria-describedby="addressHelp<%= e.getId()%>" placeholder="Dirección">
                                        <small id="addressHelp<%= e.getId()%>" class="form-text text-muted">Ej: Bulevar Louis Pasteur, Malaga, Spain.</small>
                                    </div>
                                    <div class="form-group">
                                        <label for="descInput<%= e.getId()%>">Descripción</label>
                                        <textarea type="text" class="form-control" id="descInput<%= e.getId()%>" placeholder="Descripción" maxlength="1000"></textarea>
                                    </div>
                                    <div class="form-group">
                                        <label for="dateInput<%= e.getId()%>">Fecha y hora</label>
                                        <div class="input-group">
                                            <input type="text" class="form-control calcal" id="dateInput<%= e.getId()%>" placeholder="Fecha y hora">
                                            <span class="input-group-addon" id="calendarTag<%= e.getId()%>"><i class="material-icons">date_range</i></span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="form-group col-6">
                                            <label for="categoryInput<%= e.getId()%>">Categoría</label>
                                            <select class="form-control" id="categoryInput<%= e.getId()%>">
                                                <%
                                                    for (int cat = 0; categories != null && cat < categories.size(); cat++) {
                                                %>
                                                <option value="<%= categories.get(cat).getName()%>"><%= categories.get(cat).getName()%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>
                                        <div class="form-group col-6">
                                            <label for="priceInput<%= e.getId()%>">Precio</label>
                                            <div class="input-group">
                                                <input type="number" class="form-control" id="priceInput<%= e.getId()%>" aria-describedby="euroTag<%= e.getId()%>" placeholder="Precio">
                                                <span class="input-group-addon" id="euroTag<%= e.getId()%>">€</span>
                                            </div>
                                        </div>
                                    </div>
                                    <hr>
                                    <!-- button type="submit" class="btn btn-warning">Submit</button -->
                                    <center>
                                        <span>
                                            <a class="btn btn-warning" href="/EventCRUD?opcode=1&id=<%= e.getId()%>">Borrar evento</a>
                                            <a class="btn btn-warning" href="/EventCRUD?opcode=2&id=<%= e.getId()%>">Guardar cambios</a>
                                        </span>
                                    </center>
                                </form>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                    <!-- div class="modal-footer"></div -->
                </div>
            </div>
        </div>
        <%
                }
            }
        %>

        <script src="js/jquery-3.2.1.min.js"></script>
        <script src="js/popper.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/wow.min.js"></script>
        <script>new WOW().init();</script>
        <script src="js/moment.js"></script>
        <script src="js/daterangepicker.js"></script>
        <script>
            $('.calcal').daterangepicker({
                "timePicker": true,
                "timePicker24Hour": true,
                "locale": {
                    "format": "YYYY-MM-DD HH:mm",
                    "separator": " ~ ",
                    "applyLabel": "Aceptar",
                    "cancelLabel": "Cancelar",
                    "fromLabel": "Desde",
                    "toLabel": "Hasta",
                    "customRangeLabel": "Custom",
                    "weekLabel": "W",
                    "daysOfWeek": [
                        "Do",
                        "Lu",
                        "Ma",
                        "Mi",
                        "Ju",
                        "Vi",
                        "Sa"
                    ],
                    "monthNames": [
                        "Enero",
                        "Febrero",
                        "Marzo",
                        "Abril",
                        "Mayo",
                        "Junio",
                        "Julio",
                        "Agosto",
                        "Septiembre",
                        "Octubre",
                        "Noviembre",
                        "Diciembre"
                    ],
                    "firstDay": 1
                },
                "startDate": "2018-01-01 00:00",
                "endDate": "2018-01-07 00:00",
                "opens": "left",
                "drops": "up",
                "applyClass": "btn-warning",
                "cancelClass": "btn-secondary"
            }, function (start, end, label) {});
        </script>
    </body>
</html>
