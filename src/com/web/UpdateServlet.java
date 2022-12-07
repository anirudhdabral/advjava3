package com.web;

import java.io.IOException;
import java.io.InputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.engine.jdbc.BlobProxy;

import database.ProductDetails;

@MultipartConfig(maxFileSize = 1000000)
public class UpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public UpdateServlet() {
		super();
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse response) throws ServletException, IOException {

		response.getWriter().append("Served at: ").append(req.getContextPath());
		int pid = Integer.parseInt(req.getParameter("pidq"));
		String title = req.getParameter("title");
		int quantity = Integer.parseInt(req.getParameter("quantity"));
		int size = Integer.parseInt(req.getParameter("size"));
		Part part = req.getPart("img");
		InputStream is = part.getInputStream();
		System.out.println("\n\n\n\n\n\n\n" + quantity);

		SessionFactory factory = new Configuration().configure("product.cfg.xml").buildSessionFactory();
		Session dbsession = factory.openSession();

		Transaction tx = dbsession.beginTransaction();
		ProductDetails temp = new ProductDetails(pid, title, quantity, size,
				BlobProxy.generateProxy(is, is.available()));
		dbsession.saveOrUpdate(temp);
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
