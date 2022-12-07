package com.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import database.ProductDetails;

/**
 * Servlet implementation class serv
 */
@WebServlet("/serv")
public class DeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public DeleteServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		int id = Integer.parseInt(request.getParameter("ptid"));
		SessionFactory factory = new Configuration().configure("product.cfg.xml").buildSessionFactory();
		Session dbsession = factory.openSession();
		ProductDetails p = (ProductDetails) dbsession.get(ProductDetails.class, id);
		Transaction tx = dbsession.beginTransaction();
		dbsession.remove(p);
		tx.commit();
		dbsession.close();
		factory.close();
		response.sendRedirect("index.jsp");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
