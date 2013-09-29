//    Openbravo POS is a point of sales application designed for touch screens.
//    Copyright (C) 2007-2008 Openbravo, S.L.
//    http://sourceforge.net/projects/openbravopos
//
//    This program is free software; you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation; either version 2 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program; if not, write to the Free Software
//    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

package com.openbravo.pos.payment;

import com.openbravo.pos.customers.CustomerInfoExt;
import java.awt.Component;
import com.openbravo.pos.forms.AppLocal;

public class JPaymentRefund extends javax.swing.JPanel implements JPaymentInterface {
    
    private JPaymentNotifier m_notifier;
    private double m_dTotal;
    
    private String m_sName;
    
    /** Creates new form JPaymentChequeRefund */
    public JPaymentRefund(JPaymentNotifier notifier, String sName) {
        
        m_notifier = notifier;
        m_sName = sName;
        
        initComponents();
    }
    
    public void activate(CustomerInfoExt customerext, double dTotal) {
        m_dTotal = dTotal;
        
        m_notifier.setStatus(true, true);
    }
    
    public PaymentInfo executePayment() {
        return new PaymentInfoTicket(m_dTotal, m_sName);
    }
    public Component getComponent() {
        return this;
    } 
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();

        jLabel1.setText(AppLocal.getIntString("message.paymentcashneg")); // NOI18N
        add(jLabel1);
    }// </editor-fold>//GEN-END:initComponents
    
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    // End of variables declaration//GEN-END:variables
    
}
