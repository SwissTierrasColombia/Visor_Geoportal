/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.gesp.geoportal.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author felipe
 */
public class SuggestServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        String resp = "{";
        try (PrintWriter out = response.getWriter()) {

            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String msg = request.getParameter("message");

            if (name != null && !name.isEmpty() && email != null && !email.isEmpty() && msg != null && !msg.isEmpty()) {

                System.out.println("Sending email...");

                final String username = "agenciaimplementacion@gmail.com";
                final String password = "IncigeSas2018";

                Properties props = new Properties();
                props.put("mail.smtp.starttls.enable", "true");
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.host", "smtp.gmail.com");
                props.put("mail.smtp.port", "587");

                try {

                    Session session = Session.getInstance(props,
                            new javax.mail.Authenticator() {
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(username, password);
                        }
                    });

                    Message message = new MimeMessage(session);
                    message.setContent(message, "text/html; charset=utf-8");
                    message.setFrom(new InternetAddress("lcano@appsglobals.com"));
                    message.setRecipients(Message.RecipientType.TO,
                            InternetAddress.parse("felipecanol@gmail.com"));
                    message.setSubject("Sugerencia Geoportal");
                    message.setContent(this.getMessage(name, email, msg), "text/html; charset=utf-8");

                    Transport.send(message);

                    System.out.println("Done");
                    resp += "\"status\" : \"success\",";
                    resp += "\"data\" : \"Gracias por sus comentarios.\"";

                } catch (MessagingException e) {
                    System.out.println("1 ERROR !!! " + e.getMessage());
                    resp += "\"status\" : \"error\",\"message\" : \"" + e.getMessage() + "\"";
                }catch (Exception e) {
                    System.out.println("2 ERROR !!! " + e.getMessage());
                    resp += "\"status\" : \"error\",\"message\" : \"" + e.getMessage() + "\"";
                }
            } else {
                resp += "\"status\" : \"fail\"";
                resp += ",\"data\" : {";
                String s = "";
                if (name == null || (name != null && name.isEmpty())) {
                    resp += s + "\"name\" : false";
                    s = ",";
                }
                if (email == null || (email != null && email.isEmpty())) {
                    resp += s + "\"email\" : false";
                    s = ",";
                }
                if (msg == null || (msg != null && msg.isEmpty())) {
                    resp += s + "\"message\" : false";
                }
                resp += "}";
            }
            resp += "}";
            out.println(resp);
        } catch (Exception e) {
            System.out.println("3 ERROR !!! " + e.getMessage());
        }

    }

    private String getMessage(String name, String email, String message) {
        String msg = "<!DOCTYPE html>\n"
                + "<html lang=3D&quot;en-US&quot;>\n"
                + "    <head>\n"
                + "        <meta charset=3D&quot;utf-8&quot;>\n"
                + "    </head>\n"
                + "    <body>\n"
                + "        <div class=\"container\">\n"
                + "            <div class=\"content\">\n"
                + "                <table bgcolor=\"#06857E\" width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"min-width:332px;max-width:700px;border:1px solid #e0e0e0;border-bottom:0;border-top-left-radius:3px;border-top-right-radius:3px\">\n"
                + "                    <tbody>\n"
                + "                        <tr>\n"
                + "                            <td height=\"20px\" colspan=\"3\"></td>\n"
                + "                        </tr>\n"
                + "                        <tr>\n"
                + "                            <td width=\"32px\"></td>\n"
                + "                            <td style=\"font-family:Roboto-Regular,Helvetica,Arial,sans-serif;font-size:24px;color:#ffffff;line-height:1.25;font-weight: bold;\">\n"
                + "                                !NUEVA SUGERENCIA!\n"
                + "                            </td>\n"
                + "                            <td width=\"32px\"></td>\n"
                + "                        </tr>\n"
                + "                        <tr>\n"
                + "                            <td height=\"18px\" colspan=\"3\"></td>\n"
                + "                        </tr>\n"
                + "                    </tbody>\n"
                + "                </table>\n"
                + "                <table bgcolor=\"#FAFAFA\" width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"min-width:332px;max-width:700px;border:1px solid #f0f0f0;border-bottom:1px solid #c0c0c0;border-top:0;border-bottom-left-radius:3px;border-bottom-right-radius:3px\">\n"
                + "                    <tbody>\n"
                + "                        <tr height=\"16px\">\n"
                + "                            <td width=\"32px\" rowspan=\"3\"></td>\n"
                + "                            <td></td>\n"
                + "                            <td width=\"32px\" rowspan=\"3\"></td>\n"
                + "                        </tr>\n"
                + "                        <tr>\n"
                + "                            <td>\n"
                + "                                <table style=\"min-width:300px\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n"
                + "                                    <tbody>\n"
                + "                                        <tr>\n"
                + "                                            <td style=\"font-family:Roboto-Regular,Helvetica,Arial,sans-serif;font-size:13px;color:#202020;line-height:1.5;text-align: justify;\">\n"
                + "                                                <br />\n"
                + "                                                <div>\n"
                + "                                                    <b>Nombre:</b>&nbsp;" + name
                + "                                                </div>\n"
                + "                                                <div>\n"
                + "                                                    <b>Email:</b>&nbsp;" + email
                + "                                                </div>\n"
                + "                                                <div>\n"
                + "                                                    <b>Mensaje:</b>&nbsp;" + message
                + "                                                </div>\n"
                + "                                            </td>\n"
                + "                                        </tr>\n"
                + "                                        <tr height=\"32px\"></tr>\n"
                + "                                        <tr height=\"16px\"></tr>\n"
                + "                                    </tbody>\n"
                + "                                </table>\n"
                + "                            </td>\n"
                + "                        </tr>\n"
                + "                        <tr height=\"32px\"></tr>\n"
                + "                    </tbody>\n"
                + "                </table>\n"
                + "            </div>\n"
                + "        </div>\n"
                + "    </body>\n"
                + "</html>";
        return msg;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
