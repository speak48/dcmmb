/*******************************************************************************

            Synchronous High Density Dual Port SRAM Compiler

                   UMC 0.18um Generic Logic Process
   __________________________________________________________________________


       (C) Copyright 2002-2009 Faraday Technology Corp. All Rights Reserved.

     This source code is an unpublished work belongs to Faraday Technology
     Corp.  It is considered a trade secret and is not to be divulged or
     used by parties who have not received written authorization from
     Faraday Technology Corp.

     Faraday's home page can be found at:
     http://www.faraday-tech.com/
    
________________________________________________________________________________

      Module Name       :  SJ180_4608X8X2CM16  
      Word              :  4608                
      Bit               :  8                   
      Byte              :  2                   
      Mux               :  16                  
      Power Ring Type   :  port                
      Power Ring Width  :  2 (um)              
      Output Loading    :  0.01 (pf)           
      Input Data Slew   :  0.02 (ns)           
      Input Clock Slew  :  0.02 (ns)           

________________________________________________________________________________

      Library          : FSA0A_C
      Memaker          : 200901.2.1
      Date             : 2010/06/07 14:08:57

________________________________________________________________________________


   Notice on usage: Fixed delay or timing data are given in this model.
                    It supports SDF back-annotation, please generate SDF file
                    by EDA tools to get the accurate timing.

 |-----------------------------------------------------------------------------|

   Warning : If customer's design viloate the set-up time or hold time criteria 
   of synchronous SRAM, it's possible to hit the meta-stable point of 
   latch circuit in the decoder and cause the data loss in the memory bitcell.
   So please follow the memory IP's spec to design your product.

 |-----------------------------------------------------------------------------|

                Library          : FSA0A_C
                Memaker          : 200901.2.1
                Date             : 2010/06/07 14:08:58

 *******************************************************************************/

`resetall
`timescale 10ps/1ps


module SJ180_4608X8X2CM16 (A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B0,B1,
                           B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,DOA0,DOA1,
                           DOA2,DOA3,DOA4,DOA5,DOA6,DOA7,DOA8,DOA9,
                           DOA10,DOA11,DOA12,DOA13,DOA14,DOA15,DOB0,
                           DOB1,DOB2,DOB3,DOB4,DOB5,DOB6,DOB7,DOB8,
                           DOB9,DOB10,DOB11,DOB12,DOB13,DOB14,DOB15,
                           DIA0,DIA1,DIA2,DIA3,DIA4,DIA5,DIA6,DIA7,
                           DIA8,DIA9,DIA10,DIA11,DIA12,DIA13,DIA14,
                           DIA15,DIB0,DIB1,DIB2,DIB3,DIB4,DIB5,DIB6,
                           DIB7,DIB8,DIB9,DIB10,DIB11,DIB12,DIB13,
                           DIB14,DIB15,WEAN0,WEAN1,WEBN0,WEBN1,CKA,CKB,CSA,CSB,OEA,OEB);

  `define    TRUE                 (1'b1)              
  `define    FALSE                (1'b0)              

  parameter  SYN_CS               = `TRUE;            
  parameter  NO_SER_TOH           = `TRUE;            
  parameter  AddressSize          = 13;               
  parameter  Bits                 = 8;                
  parameter  Words                = 4608;             
  parameter  Bytes                = 2;                
  parameter  AspectRatio          = 16;               
  parameter  Tr2w                 = (195:285:500);    
  parameter  Tw2r                 = (195:284:500);    
  parameter  TOH                  = (98:142:250);     

  output     DOA0,DOA1,DOA2,DOA3,DOA4,DOA5,DOA6,DOA7,DOA8,
             DOA9,DOA10,DOA11,DOA12,DOA13,DOA14,DOA15;
  output     DOB0,DOB1,DOB2,DOB3,DOB4,DOB5,DOB6,DOB7,DOB8,
             DOB9,DOB10,DOB11,DOB12,DOB13,DOB14,DOB15;
  input      DIA0,DIA1,DIA2,DIA3,DIA4,DIA5,DIA6,DIA7,DIA8,
             DIA9,DIA10,DIA11,DIA12,DIA13,DIA14,DIA15;
  input      DIB0,DIB1,DIB2,DIB3,DIB4,DIB5,DIB6,DIB7,DIB8,
             DIB9,DIB10,DIB11,DIB12,DIB13,DIB14,DIB15;
  input      A0,A1,A2,A3,A4,A5,A6,A7,A8,
             A9,A10,A11,A12;
  input      B0,B1,B2,B3,B4,B5,B6,B7,B8,
             B9,B10,B11,B12;
  input      OEA;                                     
  input      OEB;                                     
  input      WEAN0;                                   
  input      WEAN1;                                   
  input      WEBN0;                                   
  input      WEBN1;                                   
  input      CKA;                                     
  input      CKB;                                     
  input      CSA;                                     
  input      CSB;                                     

`protect
  reg        [Bits-1:0]           Memory_byte0 [Words-1:0];     
  reg        [Bits-1:0]           Memory_byte1 [Words-1:0];     

  wire       [Bytes*Bits-1:0]     DOA_;               
  wire       [Bytes*Bits-1:0]     DOB_;               
  wire       [AddressSize-1:0]    A_;                 
  wire       [AddressSize-1:0]    B_;                 
  wire                            OEA_;               
  wire                            OEB_;               
  wire       [Bits-1:0]           DIA_byte0_;         
  wire       [Bits-1:0]           DIB_byte0_;         
  wire       [Bits-1:0]           DIA_byte1_;         
  wire       [Bits-1:0]           DIB_byte1_;         
  wire                            WEBN0_;             
  wire                            WEBN1_;             
  wire                            WEAN0_;             
  wire                            WEAN1_;             
  wire                            CKA_;               
  wire                            CKB_;               
  wire                            CSA_;               
  wire                            CSB_;               

  wire                            con_A;              
  wire                            con_B;              
  wire                            con_DIA_byte0;      
  wire                            con_DIB_byte0;      
  wire                            con_DIA_byte1;      
  wire                            con_DIB_byte1;      
  wire                            con_CKA;            
  wire                            con_CKB;            
  wire                            con_WEBN0;          
  wire                            con_WEBN1;          
  wire                            con_WEAN0;          
  wire                            con_WEAN1;          

  reg        [AddressSize-1:0]    Latch_A;            
  reg        [AddressSize-1:0]    Latch_B;            
  reg        [Bits-1:0]           Latch_DIA_byte0;    
  reg        [Bits-1:0]           Latch_DIB_byte0;    
  reg        [Bits-1:0]           Latch_DIA_byte1;    
  reg        [Bits-1:0]           Latch_DIB_byte1;    
  reg                             Latch_WEAN0;        
  reg                             Latch_WEAN1;        
  reg                             Latch_WEBN0;        
  reg                             Latch_WEBN1;        
  reg                             Latch_CSA;          
  reg                             Latch_CSB;          
  reg        [AddressSize-1:0]    LastCycleAAddress;  
  reg        [AddressSize-1:0]    LastCycleBAddress;  

  reg        [AddressSize-1:0]    A_i;                
  reg        [AddressSize-1:0]    B_i;                
  reg        [Bits-1:0]           DIA_byte0_i;        
  reg        [Bits-1:0]           DIB_byte0_i;        
  reg        [Bits-1:0]           DIA_byte1_i;        
  reg        [Bits-1:0]           DIB_byte1_i;        
  reg                             WEAN0_i;            
  reg                             WEAN1_i;            
  reg                             WEBN0_i;            
  reg                             WEBN1_i;            
  reg                             CSA_i;              
  reg                             CSB_i;              

  reg                             n_flag_A0;          
  reg                             n_flag_A1;          
  reg                             n_flag_A2;          
  reg                             n_flag_A3;          
  reg                             n_flag_A4;          
  reg                             n_flag_A5;          
  reg                             n_flag_A6;          
  reg                             n_flag_A7;          
  reg                             n_flag_A8;          
  reg                             n_flag_A9;          
  reg                             n_flag_A10;         
  reg                             n_flag_A11;         
  reg                             n_flag_A12;         
  reg                             n_flag_B0;          
  reg                             n_flag_B1;          
  reg                             n_flag_B2;          
  reg                             n_flag_B3;          
  reg                             n_flag_B4;          
  reg                             n_flag_B5;          
  reg                             n_flag_B6;          
  reg                             n_flag_B7;          
  reg                             n_flag_B8;          
  reg                             n_flag_B9;          
  reg                             n_flag_B10;         
  reg                             n_flag_B11;         
  reg                             n_flag_B12;         
  reg                             n_flag_DIA0;        
  reg                             n_flag_DIB0;        
  reg                             n_flag_DIA1;        
  reg                             n_flag_DIB1;        
  reg                             n_flag_DIA2;        
  reg                             n_flag_DIB2;        
  reg                             n_flag_DIA3;        
  reg                             n_flag_DIB3;        
  reg                             n_flag_DIA4;        
  reg                             n_flag_DIB4;        
  reg                             n_flag_DIA5;        
  reg                             n_flag_DIB5;        
  reg                             n_flag_DIA6;        
  reg                             n_flag_DIB6;        
  reg                             n_flag_DIA7;        
  reg                             n_flag_DIB7;        
  reg                             n_flag_DIA8;        
  reg                             n_flag_DIB8;        
  reg                             n_flag_DIA9;        
  reg                             n_flag_DIB9;        
  reg                             n_flag_DIA10;       
  reg                             n_flag_DIB10;       
  reg                             n_flag_DIA11;       
  reg                             n_flag_DIB11;       
  reg                             n_flag_DIA12;       
  reg                             n_flag_DIB12;       
  reg                             n_flag_DIA13;       
  reg                             n_flag_DIB13;       
  reg                             n_flag_DIA14;       
  reg                             n_flag_DIB14;       
  reg                             n_flag_DIA15;       
  reg                             n_flag_DIB15;       
  reg                             n_flag_WEAN0;       
  reg                             n_flag_WEAN1;       
  reg                             n_flag_WEBN0;       
  reg                             n_flag_WEBN1;       
  reg                             n_flag_CSA;         
  reg                             n_flag_CSB;         
  reg                             n_flag_CKA_PER;     
  reg                             n_flag_CKA_MINH;    
  reg                             n_flag_CKA_MINL;    
  reg                             n_flag_CKB_PER;     
  reg                             n_flag_CKB_MINH;    
  reg                             n_flag_CKB_MINL;    
  reg                             LAST_n_flag_WEAN0;  
  reg                             LAST_n_flag_WEAN1;  
  reg                             LAST_n_flag_WEBN0;  
  reg                             LAST_n_flag_WEBN1;  
  reg                             LAST_n_flag_CSA;    
  reg                             LAST_n_flag_CSB;    
  reg                             LAST_n_flag_CKA_PER;
  reg                             LAST_n_flag_CKA_MINH;
  reg                             LAST_n_flag_CKA_MINL;
  reg                             LAST_n_flag_CKB_PER;
  reg                             LAST_n_flag_CKB_MINH;
  reg                             LAST_n_flag_CKB_MINL;
  reg        [AddressSize-1:0]    NOT_BUS_B;          
  reg        [AddressSize-1:0]    LAST_NOT_BUS_B;     
  reg        [AddressSize-1:0]    NOT_BUS_A;          
  reg        [AddressSize-1:0]    LAST_NOT_BUS_A;     
  reg        [Bits-1:0]           NOT_BUS_DIA_byte0;  
  reg        [Bits-1:0]           NOT_BUS_DIB_byte0;  
  reg        [Bits-1:0]           LAST_NOT_BUS_DIA_byte0;
  reg        [Bits-1:0]           LAST_NOT_BUS_DIB_byte0;
  reg        [Bits-1:0]           NOT_BUS_DIA_byte1;  
  reg        [Bits-1:0]           NOT_BUS_DIB_byte1;  
  reg        [Bits-1:0]           LAST_NOT_BUS_DIA_byte1;
  reg        [Bits-1:0]           LAST_NOT_BUS_DIB_byte1;

  reg        [AddressSize-1:0]    last_A;             
  reg        [AddressSize-1:0]    latch_last_A;       
  reg        [AddressSize-1:0]    last_B;             
  reg        [AddressSize-1:0]    latch_last_B;       

  reg        [Bits-1:0]           last_DIA_byte0;     
  reg        [Bits-1:0]           latch_last_DIA_byte0;
  reg        [Bits-1:0]           last_DIA_byte1;     
  reg        [Bits-1:0]           latch_last_DIA_byte1;
  reg        [Bits-1:0]           last_DIB_byte0;     
  reg        [Bits-1:0]           latch_last_DIB_byte0;
  reg        [Bits-1:0]           last_DIB_byte1;     
  reg        [Bits-1:0]           latch_last_DIB_byte1;

  reg        [Bits-1:0]           DOA_byte0_i;        
  reg        [Bits-1:0]           DOB_byte0_i;        
  reg        [Bits-1:0]           DOA_byte1_i;        
  reg        [Bits-1:0]           DOB_byte1_i;        

  reg                             LastClkAEdge;       
  reg                             LastClkBEdge;       

  reg                             Last_WEAN0_i;       
  reg                             Last_WEAN1_i;       
  reg                             Last_WEBN0_i;       
  reg                             Last_WEBN1_i;       

  reg                             flag_A_x;           
  reg                             flag_B_x;           
  reg                             flag_CSA_x;         
  reg                             flag_CSB_x;         
  reg                             NODELAYA0;          
  reg                             NODELAYB0;          
  reg                             NODELAYA1;          
  reg                             NODELAYB1;          
  reg        [Bits-1:0]           DOA_byte0_tmp;      
  reg        [Bits-1:0]           DOB_byte0_tmp;      
  event                           EventTOHDOA_byte0;  
  event                           EventTOHDOB_byte0;  
  reg        [Bits-1:0]           DOA_byte1_tmp;      
  reg        [Bits-1:0]           DOB_byte1_tmp;      
  event                           EventTOHDOA_byte1;  
  event                           EventTOHDOB_byte1;  

  time                            Last_tc_ClkA_PosEdge;
  time                            Last_tc_ClkB_PosEdge;

  assign     DOA_                 = {DOA_byte1_i,DOA_byte0_i};
  assign     DOB_                 = {DOB_byte1_i,DOB_byte0_i};
  assign     con_A                = CSA_;
  assign     con_B                = CSB_;
  assign     con_DIA_byte0        = CSA_ & (!WEAN0_);
  assign     con_DIB_byte0        = CSB_ & (!WEBN0_);
  assign     con_DIA_byte1        = CSA_ & (!WEAN1_);
  assign     con_DIB_byte1        = CSB_ & (!WEBN1_);
  assign     con_WEAN0            = CSA_;
  assign     con_WEAN1            = CSA_;
  assign     con_WEBN0            = CSB_;
  assign     con_WEBN1            = CSB_;
  assign     con_CKA              = CSA_;
  assign     con_CKB              = CSB_;

  bufif1     idoa0           (DOA0, DOA_[0], OEA_);        
  bufif1     idob0           (DOB0, DOB_[0], OEB_);        
  bufif1     idoa1           (DOA1, DOA_[1], OEA_);        
  bufif1     idob1           (DOB1, DOB_[1], OEB_);        
  bufif1     idoa2           (DOA2, DOA_[2], OEA_);        
  bufif1     idob2           (DOB2, DOB_[2], OEB_);        
  bufif1     idoa3           (DOA3, DOA_[3], OEA_);        
  bufif1     idob3           (DOB3, DOB_[3], OEB_);        
  bufif1     idoa4           (DOA4, DOA_[4], OEA_);        
  bufif1     idob4           (DOB4, DOB_[4], OEB_);        
  bufif1     idoa5           (DOA5, DOA_[5], OEA_);        
  bufif1     idob5           (DOB5, DOB_[5], OEB_);        
  bufif1     idoa6           (DOA6, DOA_[6], OEA_);        
  bufif1     idob6           (DOB6, DOB_[6], OEB_);        
  bufif1     idoa7           (DOA7, DOA_[7], OEA_);        
  bufif1     idob7           (DOB7, DOB_[7], OEB_);        
  bufif1     idoa8           (DOA8, DOA_[8], OEA_);        
  bufif1     idob8           (DOB8, DOB_[8], OEB_);        
  bufif1     idoa9           (DOA9, DOA_[9], OEA_);        
  bufif1     idob9           (DOB9, DOB_[9], OEB_);        
  bufif1     idoa10          (DOA10, DOA_[10], OEA_);      
  bufif1     idob10          (DOB10, DOB_[10], OEB_);      
  bufif1     idoa11          (DOA11, DOA_[11], OEA_);      
  bufif1     idob11          (DOB11, DOB_[11], OEB_);      
  bufif1     idoa12          (DOA12, DOA_[12], OEA_);      
  bufif1     idob12          (DOB12, DOB_[12], OEB_);      
  bufif1     idoa13          (DOA13, DOA_[13], OEA_);      
  bufif1     idob13          (DOB13, DOB_[13], OEB_);      
  bufif1     idoa14          (DOA14, DOA_[14], OEA_);      
  bufif1     idob14          (DOB14, DOB_[14], OEB_);      
  bufif1     idoa15          (DOA15, DOA_[15], OEA_);      
  bufif1     idob15          (DOB15, DOB_[15], OEB_);      
  buf        ia0             (A_[0], A0);                  
  buf        ia1             (A_[1], A1);                  
  buf        ia2             (A_[2], A2);                  
  buf        ia3             (A_[3], A3);                  
  buf        ia4             (A_[4], A4);                  
  buf        ia5             (A_[5], A5);                  
  buf        ia6             (A_[6], A6);                  
  buf        ia7             (A_[7], A7);                  
  buf        ia8             (A_[8], A8);                  
  buf        ia9             (A_[9], A9);                  
  buf        ia10            (A_[10], A10);                
  buf        ia11            (A_[11], A11);                
  buf        ia12            (A_[12], A12);                
  buf        ib0             (B_[0], B0);                  
  buf        ib1             (B_[1], B1);                  
  buf        ib2             (B_[2], B2);                  
  buf        ib3             (B_[3], B3);                  
  buf        ib4             (B_[4], B4);                  
  buf        ib5             (B_[5], B5);                  
  buf        ib6             (B_[6], B6);                  
  buf        ib7             (B_[7], B7);                  
  buf        ib8             (B_[8], B8);                  
  buf        ib9             (B_[9], B9);                  
  buf        ib10            (B_[10], B10);                
  buf        ib11            (B_[11], B11);                
  buf        ib12            (B_[12], B12);                
  buf        idia_byte0_0    (DIA_byte0_[0], DIA0);        
  buf        idib_byte0_0    (DIB_byte0_[0], DIB0);        
  buf        idia_byte0_1    (DIA_byte0_[1], DIA1);        
  buf        idib_byte0_1    (DIB_byte0_[1], DIB1);        
  buf        idia_byte0_2    (DIA_byte0_[2], DIA2);        
  buf        idib_byte0_2    (DIB_byte0_[2], DIB2);        
  buf        idia_byte0_3    (DIA_byte0_[3], DIA3);        
  buf        idib_byte0_3    (DIB_byte0_[3], DIB3);        
  buf        idia_byte0_4    (DIA_byte0_[4], DIA4);        
  buf        idib_byte0_4    (DIB_byte0_[4], DIB4);        
  buf        idia_byte0_5    (DIA_byte0_[5], DIA5);        
  buf        idib_byte0_5    (DIB_byte0_[5], DIB5);        
  buf        idia_byte0_6    (DIA_byte0_[6], DIA6);        
  buf        idib_byte0_6    (DIB_byte0_[6], DIB6);        
  buf        idia_byte0_7    (DIA_byte0_[7], DIA7);        
  buf        idib_byte0_7    (DIB_byte0_[7], DIB7);        
  buf        idia_byte1_0    (DIA_byte1_[0], DIA8);        
  buf        idib_byte1_0    (DIB_byte1_[0], DIB8);        
  buf        idia_byte1_1    (DIA_byte1_[1], DIA9);        
  buf        idib_byte1_1    (DIB_byte1_[1], DIB9);        
  buf        idia_byte1_2    (DIA_byte1_[2], DIA10);       
  buf        idib_byte1_2    (DIB_byte1_[2], DIB10);       
  buf        idia_byte1_3    (DIA_byte1_[3], DIA11);       
  buf        idib_byte1_3    (DIB_byte1_[3], DIB11);       
  buf        idia_byte1_4    (DIA_byte1_[4], DIA12);       
  buf        idib_byte1_4    (DIB_byte1_[4], DIB12);       
  buf        idia_byte1_5    (DIA_byte1_[5], DIA13);       
  buf        idib_byte1_5    (DIB_byte1_[5], DIB13);       
  buf        idia_byte1_6    (DIA_byte1_[6], DIA14);       
  buf        idib_byte1_6    (DIB_byte1_[6], DIB14);       
  buf        idia_byte1_7    (DIA_byte1_[7], DIA15);       
  buf        idib_byte1_7    (DIB_byte1_[7], DIB15);       
  buf        icka            (CKA_, CKA);                  
  buf        ickb            (CKB_, CKB);                  
  buf        icsa            (CSA_, CSA);                  
  buf        icsb            (CSB_, CSB);                  
  buf        ioea            (OEA_, OEA);                  
  buf        ioeb            (OEB_, OEB);                  
  buf        iwea0           (WEAN0_, WEAN0);              
  buf        iwea1           (WEAN1_, WEAN1);              
  buf        iweb0           (WEBN0_, WEBN0);              
  buf        iweb1           (WEBN1_, WEBN1);              

  initial begin
    $timeformat (-12, 0, " ps", 20);
    flag_A_x = `FALSE;
    flag_B_x = `FALSE;
    NODELAYA0 = 1'b0;
    NODELAYB0 = 1'b0;
    NODELAYA1 = 1'b0;
    NODELAYB1 = 1'b0;
  end


  always @(CKA_) begin
    casez ({LastClkAEdge,CKA_})
      2'b01:
         begin
           last_A = latch_last_A;
           last_DIA_byte0 = latch_last_DIA_byte0;
           last_DIA_byte1 = latch_last_DIA_byte1;
           CSA_monitor;
           pre_latch_dataA;
           memory_functionA;
           if (CSA_==1'b1) Last_tc_ClkA_PosEdge = $time;
           latch_last_A = A_;
           latch_last_DIA_byte0 = DIA_byte0_;
           latch_last_DIA_byte1 = DIA_byte1_;
         end
      2'b?x:
         begin
           ErrorMessage(0);
           if (CSA_ !== 0) begin
              if (WEAN0_ !== 1'b1) begin
                 all_core_xA(0,1);
              end else begin
                 #0 disable TOHDOA_byte0;
                 NODELAYA0 = 1'b1;
                 DOA_byte0_i = {Bits{1'bX}};
              end
              if (WEAN1_ !== 1'b1) begin
                 all_core_xA(1,1);
              end else begin
                 #0 disable TOHDOA_byte1;
                 NODELAYA1 = 1'b1;
                 DOA_byte1_i = {Bits{1'bX}};
              end
           end
         end
    endcase
    LastClkAEdge = CKA_;
  end

  always @(CKB_) begin
    casez ({LastClkBEdge,CKB_})
      2'b01:
         begin
           last_B = latch_last_B;
           last_DIB_byte0 = latch_last_DIB_byte0;
           last_DIB_byte1 = latch_last_DIB_byte1;
           CSB_monitor;
           pre_latch_dataB;
           memory_functionB;
           if (CSB_==1'b1) Last_tc_ClkB_PosEdge = $time;
           latch_last_B = B_;
           latch_last_DIB_byte0 = DIB_byte0_;
           latch_last_DIB_byte1 = DIB_byte1_;
         end
      2'b?x:
         begin
           ErrorMessage(0);
           if (CSB_ !== 0) begin
              if (WEBN0_ !== 1'b1) begin
                 all_core_xB(0,1);
              end else begin
                 #0 disable TOHDOB_byte0;
                 NODELAYB0 = 1'b1;
                 DOB_byte0_i = {Bits{1'bX}};
              end
              if (WEBN1_ !== 1'b1) begin
                 all_core_xB(1,1);
              end else begin
                 #0 disable TOHDOB_byte1;
                 NODELAYB1 = 1'b1;
                 DOB_byte1_i = {Bits{1'bX}};
              end
           end
         end
    endcase
    LastClkBEdge = CKB_;
  end

  always @(
           n_flag_A0 or
           n_flag_A1 or
           n_flag_A2 or
           n_flag_A3 or
           n_flag_A4 or
           n_flag_A5 or
           n_flag_A6 or
           n_flag_A7 or
           n_flag_A8 or
           n_flag_A9 or
           n_flag_A10 or
           n_flag_A11 or
           n_flag_A12 or
           n_flag_DIA0 or
           n_flag_DIA1 or
           n_flag_DIA2 or
           n_flag_DIA3 or
           n_flag_DIA4 or
           n_flag_DIA5 or
           n_flag_DIA6 or
           n_flag_DIA7 or
           n_flag_DIA8 or
           n_flag_DIA9 or
           n_flag_DIA10 or
           n_flag_DIA11 or
           n_flag_DIA12 or
           n_flag_DIA13 or
           n_flag_DIA14 or
           n_flag_DIA15 or
           n_flag_WEAN0 or
           n_flag_WEAN1 or
           n_flag_CSA or
           n_flag_CKA_PER or
           n_flag_CKA_MINH or
           n_flag_CKA_MINL
          )
     begin
       timingcheck_violationA;
     end

  always @(
           n_flag_B0 or
           n_flag_B1 or
           n_flag_B2 or
           n_flag_B3 or
           n_flag_B4 or
           n_flag_B5 or
           n_flag_B6 or
           n_flag_B7 or
           n_flag_B8 or
           n_flag_B9 or
           n_flag_B10 or
           n_flag_B11 or
           n_flag_B12 or
           n_flag_DIB0 or
           n_flag_DIB1 or
           n_flag_DIB2 or
           n_flag_DIB3 or
           n_flag_DIB4 or
           n_flag_DIB5 or
           n_flag_DIB6 or
           n_flag_DIB7 or
           n_flag_DIB8 or
           n_flag_DIB9 or
           n_flag_DIB10 or
           n_flag_DIB11 or
           n_flag_DIB12 or
           n_flag_DIB13 or
           n_flag_DIB14 or
           n_flag_DIB15 or
           n_flag_WEBN0 or
           n_flag_WEBN1 or
           n_flag_CSB or
           n_flag_CKB_PER or
           n_flag_CKB_MINH or
           n_flag_CKB_MINL
          )
     begin
       timingcheck_violationB;
     end


  always @(EventTOHDOA_byte0) 
    begin:TOHDOA_byte0 
      #TOH 
      NODELAYA0 <= 1'b0; 
      DOA_byte0_i              =  {Bits{1'bX}}; 
      DOA_byte0_i              <= DOA_byte0_tmp; 
  end 

  always @(EventTOHDOB_byte0) 
    begin:TOHDOB_byte0 
      #TOH 
      NODELAYB0 <= 1'b0; 
      DOB_byte0_i              =  {Bits{1'bX}}; 
      DOB_byte0_i              <= DOB_byte0_tmp; 
  end 

  always @(EventTOHDOA_byte1) 
    begin:TOHDOA_byte1 
      #TOH 
      NODELAYA1 <= 1'b0; 
      DOA_byte1_i              =  {Bits{1'bX}}; 
      DOA_byte1_i              <= DOA_byte1_tmp; 
  end 

  always @(EventTOHDOB_byte1) 
    begin:TOHDOB_byte1 
      #TOH 
      NODELAYB1 <= 1'b0; 
      DOB_byte1_i              =  {Bits{1'bX}}; 
      DOB_byte1_i              <= DOB_byte1_tmp; 
  end 


  task timingcheck_violationA;
    integer i;
    begin
      // PORT A
      if ((n_flag_CKA_PER  !== LAST_n_flag_CKA_PER)  ||
          (n_flag_CKA_MINH !== LAST_n_flag_CKA_MINH) ||
          (n_flag_CKA_MINL !== LAST_n_flag_CKA_MINL)) begin
          if (CSA_ !== 1'b0) begin
             if (WEAN0_ !== 1'b1) begin
                all_core_xA(0,1);
             end
             else begin
                #0 disable TOHDOA_byte0;
                NODELAYA0 = 1'b1;
                DOA_byte0_i = {Bits{1'bX}};
             end
             if (WEAN1_ !== 1'b1) begin
                all_core_xA(1,1);
             end
             else begin
                #0 disable TOHDOA_byte1;
                NODELAYA1 = 1'b1;
                DOA_byte1_i = {Bits{1'bX}};
             end
          end
      end
      else begin
          NOT_BUS_A  = {
                         n_flag_A12,
                         n_flag_A11,
                         n_flag_A10,
                         n_flag_A9,
                         n_flag_A8,
                         n_flag_A7,
                         n_flag_A6,
                         n_flag_A5,
                         n_flag_A4,
                         n_flag_A3,
                         n_flag_A2,
                         n_flag_A1,
                         n_flag_A0};

          NOT_BUS_DIA_byte0  = {
                         n_flag_DIA7,
                         n_flag_DIA6,
                         n_flag_DIA5,
                         n_flag_DIA4,
                         n_flag_DIA3,
                         n_flag_DIA2,
                         n_flag_DIA1,
                         n_flag_DIA0};

          NOT_BUS_DIA_byte1  = {
                         n_flag_DIA15,
                         n_flag_DIA14,
                         n_flag_DIA13,
                         n_flag_DIA12,
                         n_flag_DIA11,
                         n_flag_DIA10,
                         n_flag_DIA9,
                         n_flag_DIA8};

          for (i=0; i<AddressSize; i=i+1) begin
             Latch_A[i] = (NOT_BUS_A[i] !== LAST_NOT_BUS_A[i]) ? 1'bx : Latch_A[i];
          end
          for (i=0; i<Bits; i=i+1) begin
             Latch_DIA_byte0[i] = (NOT_BUS_DIA_byte0[i] !== LAST_NOT_BUS_DIA_byte0[i]) ? 1'bx : Latch_DIA_byte0[i];
             Latch_DIA_byte1[i] = (NOT_BUS_DIA_byte1[i] !== LAST_NOT_BUS_DIA_byte1[i]) ? 1'bx : Latch_DIA_byte1[i];
          end
          Latch_CSA  =  (n_flag_CSA  !== LAST_n_flag_CSA)  ? 1'bx : Latch_CSA;
          Latch_WEAN0 = (n_flag_WEAN0 !== LAST_n_flag_WEAN0)  ? 1'bx : Latch_WEAN0;
          Latch_WEAN1 = (n_flag_WEAN1 !== LAST_n_flag_WEAN1)  ? 1'bx : Latch_WEAN1;
          memory_functionA;
      end

      LAST_NOT_BUS_A                 = NOT_BUS_A;
      LAST_NOT_BUS_DIA_byte0         = NOT_BUS_DIA_byte0;
      LAST_NOT_BUS_DIA_byte1         = NOT_BUS_DIA_byte1;
      LAST_n_flag_WEAN0              = n_flag_WEAN0;
      LAST_n_flag_WEAN1              = n_flag_WEAN1;
      LAST_n_flag_CSA                = n_flag_CSA;
      LAST_n_flag_CKA_PER            = n_flag_CKA_PER;
      LAST_n_flag_CKA_MINH           = n_flag_CKA_MINH;
      LAST_n_flag_CKA_MINL           = n_flag_CKA_MINL;
    end
  endtask // end timingcheck_violationA;

  task timingcheck_violationB;
    integer i;
    begin
      // PORT B
      if ((n_flag_CKB_PER  !== LAST_n_flag_CKB_PER)  ||
          (n_flag_CKB_MINH !== LAST_n_flag_CKB_MINH) ||
          (n_flag_CKB_MINL !== LAST_n_flag_CKB_MINL)) begin
          if (CSB_ !== 1'b0) begin
             if (WEBN0_ !== 1'b1) begin
                all_core_xB(0,1);
             end
             else begin
                #0 disable TOHDOB_byte0;
                NODELAYB0 = 1'b1;
                DOB_byte0_i = {Bits{1'bX}};
             end
             if (WEBN1_ !== 1'b1) begin
                all_core_xB(1,1);
             end
             else begin
                #0 disable TOHDOB_byte1;
                NODELAYB1 = 1'b1;
                DOB_byte1_i = {Bits{1'bX}};
             end
          end
      end
      else begin
          NOT_BUS_B  = {
                         n_flag_B12,
                         n_flag_B11,
                         n_flag_B10,
                         n_flag_B9,
                         n_flag_B8,
                         n_flag_B7,
                         n_flag_B6,
                         n_flag_B5,
                         n_flag_B4,
                         n_flag_B3,
                         n_flag_B2,
                         n_flag_B1,
                         n_flag_B0};

          NOT_BUS_DIB_byte0  = {
                         n_flag_DIB7,
                         n_flag_DIB6,
                         n_flag_DIB5,
                         n_flag_DIB4,
                         n_flag_DIB3,
                         n_flag_DIB2,
                         n_flag_DIB1,
                         n_flag_DIB0};

          NOT_BUS_DIB_byte1  = {
                         n_flag_DIB15,
                         n_flag_DIB14,
                         n_flag_DIB13,
                         n_flag_DIB12,
                         n_flag_DIB11,
                         n_flag_DIB10,
                         n_flag_DIB9,
                         n_flag_DIB8};

          for (i=0; i<AddressSize; i=i+1) begin
             Latch_B[i] = (NOT_BUS_B[i] !== LAST_NOT_BUS_B[i]) ? 1'bx : Latch_B[i];
          end
          for (i=0; i<Bits; i=i+1) begin
             Latch_DIB_byte0[i] = (NOT_BUS_DIB_byte0[i] !== LAST_NOT_BUS_DIB_byte0[i]) ? 1'bx : Latch_DIB_byte0[i];
             Latch_DIB_byte1[i] = (NOT_BUS_DIB_byte1[i] !== LAST_NOT_BUS_DIB_byte1[i]) ? 1'bx : Latch_DIB_byte1[i];
          end
          Latch_CSB  =  (n_flag_CSB  !== LAST_n_flag_CSB)  ? 1'bx : Latch_CSB;
          Latch_WEBN0 = (n_flag_WEBN0 !== LAST_n_flag_WEBN0)  ? 1'bx : Latch_WEBN0;
          Latch_WEBN1 = (n_flag_WEBN1 !== LAST_n_flag_WEBN1)  ? 1'bx : Latch_WEBN1;
          memory_functionB;
      end

      LAST_NOT_BUS_B                 = NOT_BUS_B;
      LAST_NOT_BUS_DIB_byte0         = NOT_BUS_DIB_byte0;
      LAST_NOT_BUS_DIB_byte1         = NOT_BUS_DIB_byte1;
      LAST_n_flag_WEBN0              = n_flag_WEBN0;
      LAST_n_flag_WEBN1              = n_flag_WEBN1;
      LAST_n_flag_CSB                = n_flag_CSB;
      LAST_n_flag_CKB_PER            = n_flag_CKB_PER;
      LAST_n_flag_CKB_MINH           = n_flag_CKB_MINH;
      LAST_n_flag_CKB_MINL           = n_flag_CKB_MINL;
    end
  endtask // end timingcheck_violationB;

  task pre_latch_dataA;
    begin
      Latch_A                        = A_;
      Latch_DIA_byte0                = DIA_byte0_;
      Latch_DIA_byte1                = DIA_byte1_;
      Latch_CSA                      = CSA_;
      Latch_WEAN0                    = WEAN0_;
      Latch_WEAN1                    = WEAN1_;
    end
  endtask //end pre_latch_dataA

  task pre_latch_dataB;
    begin
      Latch_B                        = B_;
      Latch_DIB_byte0                = DIB_byte0_;
      Latch_DIB_byte1                = DIB_byte1_;
      Latch_CSB                      = CSB_;
      Latch_WEBN0                    = WEBN0_;
      Latch_WEBN1                    = WEBN1_;
    end
  endtask //end pre_latch_dataB

  task memory_functionA;
    begin
      A_i                            = Latch_A;
      DIA_byte0_i                    = Latch_DIA_byte0;
      DIA_byte1_i                    = Latch_DIA_byte1;
      WEAN0_i                        = Latch_WEAN0;
      WEAN1_i                        = Latch_WEAN1;
      CSA_i                          = Latch_CSA;

      if (CSA_ == 1'b1) A_monitor;


      casez({WEAN0_i,CSA_i})
        2'b11: begin
           if (AddressRangeCheck(A_i)) begin
              if ((A_i == LastCycleBAddress)&&
                  (Last_WEBN0_i == 1'b0) &&
                  ($time-Last_tc_ClkB_PosEdge<Tw2r)) begin
                  ErrorMessage(1);
                  #0 disable TOHDOA_byte0;
                  NODELAYA0 = 1'b1;
                  DOA_byte0_i = {Bits{1'bX}};
              end else begin
                  if (NO_SER_TOH == `TRUE) begin
                     if (A_i !== last_A) begin
                        NODELAYA0 = 1'b1;
                        DOA_byte0_tmp = Memory_byte0[A_i];
                        ->EventTOHDOA_byte0;
                     end else begin
                        NODELAYA0 = 1'b0;
                        DOA_byte0_tmp = Memory_byte0[A_i];
                        DOA_byte0_i = DOA_byte0_tmp;
                     end
                  end else begin
                     NODELAYA0 = 1'b1;
                     DOA_byte0_tmp = Memory_byte0[A_i];
                     ->EventTOHDOA_byte0;
                  end
              end
           end
           else begin
                #0 disable TOHDOA_byte0;
                NODELAYA0 = 1'b1;
                DOA_byte0_i = {Bits{1'bX}};
           end
           LastCycleAAddress = A_i;
        end
        2'b01: begin
           if (AddressRangeCheck(A_i)) begin
              if (A_i == LastCycleBAddress) begin
                 if ((Last_WEBN0_i == 1'b1)&&($time-Last_tc_ClkB_PosEdge<Tr2w)) begin
                    ErrorMessage(1);
                    #0 disable TOHDOB_byte0;
                    NODELAYB0 = 1'b1;
                    DOB_byte0_i = {Bits{1'bX}};
                    Memory_byte0[A_i] = DIA_byte0_i;
                 end else if ((Last_WEBN0_i == 1'b0)&&($time-Last_tc_ClkB_PosEdge<Tw2r)) begin
                    ErrorMessage(4);
                    Memory_byte0[A_i] = {Bits{1'bX}};
                 end else begin
                    Memory_byte0[A_i] = DIA_byte0_i;
                 end
              end else begin
                 Memory_byte0[A_i] = DIA_byte0_i;
              end
              if (NO_SER_TOH == `TRUE) begin
                 if (A_i !== last_A) begin
                    NODELAYA0 = 1'b1;
                    DOA_byte0_tmp = Memory_byte0[A_i];
                    ->EventTOHDOA_byte0;
                 end else begin
                    if (DIA_byte0_i !== last_DIA_byte0) begin
                       NODELAYA0 = 1'b1;
                       DOA_byte0_tmp = Memory_byte0[A_i];
                       ->EventTOHDOA_byte0;
                    end else begin
                      NODELAYA0 = 1'b0;
                      DOA_byte0_tmp = Memory_byte0[A_i];
                      DOA_byte0_i = DOA_byte0_tmp;
                    end
                 end
              end else begin
                 NODELAYA0 = 1'b1;
                 DOA_byte0_tmp = Memory_byte0[A_i];
                 ->EventTOHDOA_byte0;
              end
           end else begin
                all_core_xA(0,1);
           end
           LastCycleAAddress = A_i;
        end
        2'b1x: begin
           #0 disable TOHDOA_byte0;
           NODELAYA0 = 1'b1;
           DOA_byte0_i = {Bits{1'bX}};
        end
        2'b0x,
        2'bx1,
        2'bxx: begin
           if (AddressRangeCheck(A_i)) begin
                Memory_byte0[A_i] = {Bits{1'bX}};
                #0 disable TOHDOA_byte0;
                NODELAYA0 = 1'b1;
                DOA_byte0_i = {Bits{1'bX}};
           end else begin
                all_core_xA(0,1);
           end
        end
      endcase
      Last_WEAN0_i = WEAN0_i;

      casez({WEAN1_i,CSA_i})
        2'b11: begin
           if (AddressRangeCheck(A_i)) begin
              if ((A_i == LastCycleBAddress)&&
                  (Last_WEBN1_i == 1'b0) &&
                  ($time-Last_tc_ClkB_PosEdge<Tw2r)) begin
                  ErrorMessage(1);
                  #0 disable TOHDOA_byte1;
                  NODELAYA1 = 1'b1;
                  DOA_byte1_i = {Bits{1'bX}};
              end else begin
                  if (NO_SER_TOH == `TRUE) begin
                     if (A_i !== last_A) begin
                        NODELAYA1 = 1'b1;
                        DOA_byte1_tmp = Memory_byte1[A_i];
                        ->EventTOHDOA_byte1;
                     end else begin
                        NODELAYA1 = 1'b0;
                        DOA_byte1_tmp = Memory_byte1[A_i];
                        DOA_byte1_i = DOA_byte1_tmp;
                     end
                  end else begin
                     NODELAYA1 = 1'b1;
                     DOA_byte1_tmp = Memory_byte1[A_i];
                     ->EventTOHDOA_byte1;
                  end
              end
           end
           else begin
                #0 disable TOHDOA_byte1;
                NODELAYA1 = 1'b1;
                DOA_byte1_i = {Bits{1'bX}};
           end
           LastCycleAAddress = A_i;
        end
        2'b01: begin
           if (AddressRangeCheck(A_i)) begin
              if (A_i == LastCycleBAddress) begin
                 if ((Last_WEBN1_i == 1'b1)&&($time-Last_tc_ClkB_PosEdge<Tr2w)) begin
                    ErrorMessage(1);
                    #0 disable TOHDOB_byte1;
                    NODELAYB1 = 1'b1;
                    DOB_byte1_i = {Bits{1'bX}};
                    Memory_byte1[A_i] = DIA_byte1_i;
                 end else if ((Last_WEBN1_i == 1'b0)&&($time-Last_tc_ClkB_PosEdge<Tw2r)) begin
                    ErrorMessage(4);
                    Memory_byte1[A_i] = {Bits{1'bX}};
                 end else begin
                    Memory_byte1[A_i] = DIA_byte1_i;
                 end
              end else begin
                 Memory_byte1[A_i] = DIA_byte1_i;
              end
              if (NO_SER_TOH == `TRUE) begin
                 if (A_i !== last_A) begin
                    NODELAYA1 = 1'b1;
                    DOA_byte1_tmp = Memory_byte1[A_i];
                    ->EventTOHDOA_byte1;
                 end else begin
                    if (DIA_byte1_i !== last_DIA_byte1) begin
                       NODELAYA1 = 1'b1;
                       DOA_byte1_tmp = Memory_byte1[A_i];
                       ->EventTOHDOA_byte1;
                    end else begin
                      NODELAYA1 = 1'b0;
                      DOA_byte1_tmp = Memory_byte1[A_i];
                      DOA_byte1_i = DOA_byte1_tmp;
                    end
                 end
              end else begin
                 NODELAYA1 = 1'b1;
                 DOA_byte1_tmp = Memory_byte1[A_i];
                 ->EventTOHDOA_byte1;
              end
           end else begin
                all_core_xA(1,1);
           end
           LastCycleAAddress = A_i;
        end
        2'b1x: begin
           #0 disable TOHDOA_byte1;
           NODELAYA1 = 1'b1;
           DOA_byte1_i = {Bits{1'bX}};
        end
        2'b0x,
        2'bx1,
        2'bxx: begin
           if (AddressRangeCheck(A_i)) begin
                Memory_byte1[A_i] = {Bits{1'bX}};
                #0 disable TOHDOA_byte1;
                NODELAYA1 = 1'b1;
                DOA_byte1_i = {Bits{1'bX}};
           end else begin
                all_core_xA(1,1);
           end
        end
      endcase
      Last_WEAN1_i = WEAN1_i;
  end
  endtask //memory_functionA;

  task memory_functionB;
    begin
      B_i                            = Latch_B;
      DIB_byte0_i                    = Latch_DIB_byte0;
      DIB_byte1_i                    = Latch_DIB_byte1;
      WEBN0_i                        = Latch_WEBN0;
      WEBN1_i                        = Latch_WEBN1;
      CSB_i                          = Latch_CSB;

      if (CSB_ == 1'b1) B_monitor;


      casez({WEBN0_i,CSB_i})
        2'b11: begin
           if (AddressRangeCheck(B_i)) begin
              if ((B_i == LastCycleAAddress)&&
                  (Last_WEAN0_i == 1'b0) &&
                  ($time-Last_tc_ClkA_PosEdge<Tw2r)) begin
                  ErrorMessage(1);
                  #0 disable TOHDOB_byte0;
                  NODELAYB0 = 1'b1;
                  DOB_byte0_i = {Bits{1'bX}};
              end else begin
                  if (NO_SER_TOH == `TRUE) begin
                     if (B_i !== last_B) begin
                        NODELAYB0 = 1'b1;
                        DOB_byte0_tmp = Memory_byte0[B_i];
                        ->EventTOHDOB_byte0;
                     end else begin
                        NODELAYB0 = 1'b0;
                        DOB_byte0_tmp = Memory_byte0[B_i];
                        DOB_byte0_i = DOB_byte0_tmp;
                     end
                  end else begin
                     NODELAYB0 = 1'b1;
                     DOB_byte0_tmp = Memory_byte0[B_i];
                     ->EventTOHDOB_byte0;
                  end
              end
           end
           else begin
                #0 disable TOHDOB_byte0;
                NODELAYB0 = 1'b1;
                DOB_byte0_i = {Bits{1'bX}};
           end
           LastCycleBAddress = B_i;
        end
        2'b01: begin
           if (AddressRangeCheck(B_i)) begin
              if (B_i == LastCycleAAddress) begin
                 if ((Last_WEAN0_i == 1'b1)&&($time-Last_tc_ClkA_PosEdge<Tr2w)) begin
                    ErrorMessage(1);
                    #0 disable TOHDOA_byte0;
                    NODELAYA0 = 1'b1;
                    DOA_byte0_i = {Bits{1'bX}};
                    Memory_byte0[B_i] = DIB_byte0_i;
                 end else if ((Last_WEAN0_i == 1'b0)&&($time-Last_tc_ClkA_PosEdge<Tw2r)) begin
                    ErrorMessage(4);
                    Memory_byte0[B_i] = {Bits{1'bX}};
                 end else begin
                    Memory_byte0[B_i] = DIB_byte0_i;
                 end
              end else begin
                 Memory_byte0[B_i] = DIB_byte0_i;
              end
              if (NO_SER_TOH == `TRUE) begin
                 if (B_i !== last_B) begin
                    NODELAYB0 = 1'b1;
                    DOB_byte0_tmp = Memory_byte0[B_i];
                    ->EventTOHDOB_byte0;
                 end else begin
                    if (DIB_byte0_i !== last_DIB_byte0) begin
                       NODELAYB0 = 1'b1;
                       DOB_byte0_tmp = Memory_byte0[B_i];
                       ->EventTOHDOB_byte0;
                    end else begin
                      NODELAYB0 = 1'b0;
                      DOB_byte0_tmp = Memory_byte0[B_i];
                      DOB_byte0_i = DOB_byte0_tmp;
                    end
                 end
              end else begin
                 NODELAYB0 = 1'b1;
                 DOB_byte0_tmp = Memory_byte0[B_i];
                 ->EventTOHDOB_byte0;
              end
           end else begin
                all_core_xB(0,1);
           end
           LastCycleBAddress = B_i;
        end
        2'b1x: begin
           #0 disable TOHDOB_byte0;
           NODELAYB0 = 1'b1;
           DOB_byte0_i = {Bits{1'bX}};
        end
        2'b0x,
        2'bx1,
        2'bxx: begin
           if (AddressRangeCheck(B_i)) begin
                Memory_byte0[B_i] = {Bits{1'bX}};
                #0 disable TOHDOB_byte0;
                NODELAYB0 = 1'b1;
                DOB_byte0_i = {Bits{1'bX}};
           end else begin
                all_core_xB(0,1);
           end
        end
      endcase
      Last_WEBN0_i = WEBN0_i;

      casez({WEBN1_i,CSB_i})
        2'b11: begin
           if (AddressRangeCheck(B_i)) begin
              if ((B_i == LastCycleAAddress)&&
                  (Last_WEAN1_i == 1'b0) &&
                  ($time-Last_tc_ClkA_PosEdge<Tw2r)) begin
                  ErrorMessage(1);
                  #0 disable TOHDOB_byte1;
                  NODELAYB1 = 1'b1;
                  DOB_byte1_i = {Bits{1'bX}};
              end else begin
                  if (NO_SER_TOH == `TRUE) begin
                     if (B_i !== last_B) begin
                        NODELAYB1 = 1'b1;
                        DOB_byte1_tmp = Memory_byte1[B_i];
                        ->EventTOHDOB_byte1;
                     end else begin
                        NODELAYB1 = 1'b0;
                        DOB_byte1_tmp = Memory_byte1[B_i];
                        DOB_byte1_i = DOB_byte1_tmp;
                     end
                  end else begin
                     NODELAYB1 = 1'b1;
                     DOB_byte1_tmp = Memory_byte1[B_i];
                     ->EventTOHDOB_byte1;
                  end
              end
           end
           else begin
                #0 disable TOHDOB_byte1;
                NODELAYB1 = 1'b1;
                DOB_byte1_i = {Bits{1'bX}};
           end
           LastCycleBAddress = B_i;
        end
        2'b01: begin
           if (AddressRangeCheck(B_i)) begin
              if (B_i == LastCycleAAddress) begin
                 if ((Last_WEAN1_i == 1'b1)&&($time-Last_tc_ClkA_PosEdge<Tr2w)) begin
                    ErrorMessage(1);
                    #0 disable TOHDOA_byte1;
                    NODELAYA1 = 1'b1;
                    DOA_byte1_i = {Bits{1'bX}};
                    Memory_byte1[B_i] = DIB_byte1_i;
                 end else if ((Last_WEAN1_i == 1'b0)&&($time-Last_tc_ClkA_PosEdge<Tw2r)) begin
                    ErrorMessage(4);
                    Memory_byte1[B_i] = {Bits{1'bX}};
                 end else begin
                    Memory_byte1[B_i] = DIB_byte1_i;
                 end
              end else begin
                 Memory_byte1[B_i] = DIB_byte1_i;
              end
              if (NO_SER_TOH == `TRUE) begin
                 if (B_i !== last_B) begin
                    NODELAYB1 = 1'b1;
                    DOB_byte1_tmp = Memory_byte1[B_i];
                    ->EventTOHDOB_byte1;
                 end else begin
                    if (DIB_byte1_i !== last_DIB_byte1) begin
                       NODELAYB1 = 1'b1;
                       DOB_byte1_tmp = Memory_byte1[B_i];
                       ->EventTOHDOB_byte1;
                    end else begin
                      NODELAYB1 = 1'b0;
                      DOB_byte1_tmp = Memory_byte1[B_i];
                      DOB_byte1_i = DOB_byte1_tmp;
                    end
                 end
              end else begin
                 NODELAYB1 = 1'b1;
                 DOB_byte1_tmp = Memory_byte1[B_i];
                 ->EventTOHDOB_byte1;
              end
           end else begin
                all_core_xB(1,1);
           end
           LastCycleBAddress = B_i;
        end
        2'b1x: begin
           #0 disable TOHDOB_byte1;
           NODELAYB1 = 1'b1;
           DOB_byte1_i = {Bits{1'bX}};
        end
        2'b0x,
        2'bx1,
        2'bxx: begin
           if (AddressRangeCheck(B_i)) begin
                Memory_byte1[B_i] = {Bits{1'bX}};
                #0 disable TOHDOB_byte1;
                NODELAYB1 = 1'b1;
                DOB_byte1_i = {Bits{1'bX}};
           end else begin
                all_core_xB(1,1);
           end
        end
      endcase
      Last_WEBN1_i = WEBN1_i;
  end
  endtask //memory_functionB;

  task all_core_xA;
     input byte_num;
     input do_x;

     integer byte_num;
     integer do_x;
     integer LoopCount_Address;
     begin
       LoopCount_Address=Words-1;
       while(LoopCount_Address >=0) begin
          case (byte_num)
             0       : begin
                         Memory_byte0[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOA_byte0;
                            NODELAYA0 = 1'b1;
                            DOA_byte0_i = {Bits{1'bX}};
                         end
                       end
             1       : begin
                         Memory_byte1[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOA_byte1;
                            NODELAYA1 = 1'b1;
                            DOA_byte1_i = {Bits{1'bX}};
                         end
                       end
             default : begin
                         Memory_byte0[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOA_byte0;
                            NODELAYA0 = 1'b1;
                            DOA_byte0_i = {Bits{1'bX}};
                         end
                         Memory_byte1[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOA_byte1;
                            NODELAYA1 = 1'b1;
                            DOA_byte1_i = {Bits{1'bX}};
                         end
                       end
         endcase
         LoopCount_Address=LoopCount_Address-1;
      end
    end
  endtask //end all_core_xA;

  task all_core_xB;
     input byte_num;
     input do_x;

     integer byte_num;
     integer do_x;
     integer LoopCount_Address;
     begin
       LoopCount_Address=Words-1;
       while(LoopCount_Address >=0) begin
          case (byte_num)
             0       : begin
                         Memory_byte0[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOB_byte0;
                            NODELAYB0 = 1'b1;
                            DOB_byte0_i = {Bits{1'bX}};
                         end
                       end
             1       : begin
                         Memory_byte1[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOB_byte1;
                            NODELAYB1 = 1'b1;
                            DOB_byte1_i = {Bits{1'bX}};
                         end
                       end
             default : begin
                         Memory_byte0[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOB_byte0;
                            NODELAYB0 = 1'b1;
                            DOB_byte0_i = {Bits{1'bX}};
                         end
                         Memory_byte1[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOB_byte1;
                            NODELAYB1 = 1'b1;
                            DOB_byte1_i = {Bits{1'bX}};
                         end
                       end
         endcase
         LoopCount_Address=LoopCount_Address-1;
      end
    end
  endtask //end all_core_xB;

  task A_monitor;
     begin
       if (^(A_) !== 1'bX) begin
          flag_A_x = `FALSE;
       end
       else begin
          if (flag_A_x == `FALSE) begin
              flag_A_x = `TRUE;
              ErrorMessage(2);
          end
       end
     end
  endtask //end A_monitor;

  task B_monitor;
     begin
       if (^(B_) !== 1'bX) begin
          flag_B_x = `FALSE;
       end
       else begin
          if (flag_B_x == `FALSE) begin
              flag_B_x = `TRUE;
              ErrorMessage(2);
          end
       end
     end
  endtask //end B_monitor;

  task CSA_monitor;
     begin
       if (^(CSA_) !== 1'bX) begin
          flag_CSA_x = `FALSE;
       end
       else begin
          if (flag_CSA_x == `FALSE) begin
              flag_CSA_x = `TRUE;
              ErrorMessage(3);
          end
       end
     end
  endtask //end CSA_monitor;

  task CSB_monitor;
     begin
       if (^(CSB_) !== 1'bX) begin
          flag_CSB_x = `FALSE;
       end
       else begin
          if (flag_CSB_x == `FALSE) begin
              flag_CSB_x = `TRUE;
              ErrorMessage(3);
          end
       end
     end
  endtask //end CSB_monitor;

  task ErrorMessage;
     input error_type;
     integer error_type;

     begin
       case (error_type)
         0: $display("** MEM_Error: Abnormal transition occurred (%t) in Clock of %m",$time);
         1: $display("** MEM_Warning: Read and Write the same Address, DO is unknown (%t) in clock of %m",$time);
         2: $display("** MEM_Error: Unknown value occurred (%t) in Address of %m",$time);
         3: $display("** MEM_Error: Unknown value occurred (%t) in ChipSelect of %m",$time);
         4: $display("** MEM_Error: Port A and B write the same Address, core is unknown (%t) in clock of %m",$time);
         5: $display("** MEM_Error: Clear all memory core to unknown (%t) in clock of %m",$time);
       endcase
     end
  endtask

  function AddressRangeCheck;
      input  [AddressSize-1:0] AddressItem;
      reg    UnaryResult;
      begin
        UnaryResult = ^AddressItem;
        if(UnaryResult!==1'bX) begin
           if (AddressItem >= Words) begin
              $display("** MEM_Error: Out of range occurred (%t) in Address of %m",$time);
              AddressRangeCheck = `FALSE;
           end else begin
              AddressRangeCheck = `TRUE;
           end
        end
        else begin
           AddressRangeCheck = `FALSE;
        end
      end
  endfunction //end AddressRangeCheck;

   specify
      specparam TAA  = (159:235:423);
      specparam TRC  = (195:285:500);
      specparam THPW = (20:28:45);
      specparam TLPW = (20:28:45);
      specparam TAS  = (35:52:91);
      specparam TAH  = (6:9:14);
      specparam TWS  = (21:32:56);
      specparam TWH  = (4:5:7);
      specparam TDS  = (29:45:78);
      specparam TDH  = (7:7:5);
      specparam TCSS = (52:77:133);
      specparam TCSH = (9:14:24);
      specparam TOE  = (38:54:92);
      specparam TOZ  = (29:40:67);


      $setuphold ( posedge CKA &&& con_A,         posedge A0, TAS,     TAH,     n_flag_A0      );
      $setuphold ( posedge CKA &&& con_A,         negedge A0, TAS,     TAH,     n_flag_A0      );
      $setuphold ( posedge CKA &&& con_A,         posedge A1, TAS,     TAH,     n_flag_A1      );
      $setuphold ( posedge CKA &&& con_A,         negedge A1, TAS,     TAH,     n_flag_A1      );
      $setuphold ( posedge CKA &&& con_A,         posedge A2, TAS,     TAH,     n_flag_A2      );
      $setuphold ( posedge CKA &&& con_A,         negedge A2, TAS,     TAH,     n_flag_A2      );
      $setuphold ( posedge CKA &&& con_A,         posedge A3, TAS,     TAH,     n_flag_A3      );
      $setuphold ( posedge CKA &&& con_A,         negedge A3, TAS,     TAH,     n_flag_A3      );
      $setuphold ( posedge CKA &&& con_A,         posedge A4, TAS,     TAH,     n_flag_A4      );
      $setuphold ( posedge CKA &&& con_A,         negedge A4, TAS,     TAH,     n_flag_A4      );
      $setuphold ( posedge CKA &&& con_A,         posedge A5, TAS,     TAH,     n_flag_A5      );
      $setuphold ( posedge CKA &&& con_A,         negedge A5, TAS,     TAH,     n_flag_A5      );
      $setuphold ( posedge CKA &&& con_A,         posedge A6, TAS,     TAH,     n_flag_A6      );
      $setuphold ( posedge CKA &&& con_A,         negedge A6, TAS,     TAH,     n_flag_A6      );
      $setuphold ( posedge CKA &&& con_A,         posedge A7, TAS,     TAH,     n_flag_A7      );
      $setuphold ( posedge CKA &&& con_A,         negedge A7, TAS,     TAH,     n_flag_A7      );
      $setuphold ( posedge CKA &&& con_A,         posedge A8, TAS,     TAH,     n_flag_A8      );
      $setuphold ( posedge CKA &&& con_A,         negedge A8, TAS,     TAH,     n_flag_A8      );
      $setuphold ( posedge CKA &&& con_A,         posedge A9, TAS,     TAH,     n_flag_A9      );
      $setuphold ( posedge CKA &&& con_A,         negedge A9, TAS,     TAH,     n_flag_A9      );
      $setuphold ( posedge CKA &&& con_A,         posedge A10, TAS,     TAH,     n_flag_A10     );
      $setuphold ( posedge CKA &&& con_A,         negedge A10, TAS,     TAH,     n_flag_A10     );
      $setuphold ( posedge CKA &&& con_A,         posedge A11, TAS,     TAH,     n_flag_A11     );
      $setuphold ( posedge CKA &&& con_A,         negedge A11, TAS,     TAH,     n_flag_A11     );
      $setuphold ( posedge CKA &&& con_A,         posedge A12, TAS,     TAH,     n_flag_A12     );
      $setuphold ( posedge CKA &&& con_A,         negedge A12, TAS,     TAH,     n_flag_A12     );
      $setuphold ( posedge CKB &&& con_B,         posedge B0, TAS,     TAH,     n_flag_B0      );
      $setuphold ( posedge CKB &&& con_B,         negedge B0, TAS,     TAH,     n_flag_B0      );
      $setuphold ( posedge CKB &&& con_B,         posedge B1, TAS,     TAH,     n_flag_B1      );
      $setuphold ( posedge CKB &&& con_B,         negedge B1, TAS,     TAH,     n_flag_B1      );
      $setuphold ( posedge CKB &&& con_B,         posedge B2, TAS,     TAH,     n_flag_B2      );
      $setuphold ( posedge CKB &&& con_B,         negedge B2, TAS,     TAH,     n_flag_B2      );
      $setuphold ( posedge CKB &&& con_B,         posedge B3, TAS,     TAH,     n_flag_B3      );
      $setuphold ( posedge CKB &&& con_B,         negedge B3, TAS,     TAH,     n_flag_B3      );
      $setuphold ( posedge CKB &&& con_B,         posedge B4, TAS,     TAH,     n_flag_B4      );
      $setuphold ( posedge CKB &&& con_B,         negedge B4, TAS,     TAH,     n_flag_B4      );
      $setuphold ( posedge CKB &&& con_B,         posedge B5, TAS,     TAH,     n_flag_B5      );
      $setuphold ( posedge CKB &&& con_B,         negedge B5, TAS,     TAH,     n_flag_B5      );
      $setuphold ( posedge CKB &&& con_B,         posedge B6, TAS,     TAH,     n_flag_B6      );
      $setuphold ( posedge CKB &&& con_B,         negedge B6, TAS,     TAH,     n_flag_B6      );
      $setuphold ( posedge CKB &&& con_B,         posedge B7, TAS,     TAH,     n_flag_B7      );
      $setuphold ( posedge CKB &&& con_B,         negedge B7, TAS,     TAH,     n_flag_B7      );
      $setuphold ( posedge CKB &&& con_B,         posedge B8, TAS,     TAH,     n_flag_B8      );
      $setuphold ( posedge CKB &&& con_B,         negedge B8, TAS,     TAH,     n_flag_B8      );
      $setuphold ( posedge CKB &&& con_B,         posedge B9, TAS,     TAH,     n_flag_B9      );
      $setuphold ( posedge CKB &&& con_B,         negedge B9, TAS,     TAH,     n_flag_B9      );
      $setuphold ( posedge CKB &&& con_B,         posedge B10, TAS,     TAH,     n_flag_B10     );
      $setuphold ( posedge CKB &&& con_B,         negedge B10, TAS,     TAH,     n_flag_B10     );
      $setuphold ( posedge CKB &&& con_B,         posedge B11, TAS,     TAH,     n_flag_B11     );
      $setuphold ( posedge CKB &&& con_B,         negedge B11, TAS,     TAH,     n_flag_B11     );
      $setuphold ( posedge CKB &&& con_B,         posedge B12, TAS,     TAH,     n_flag_B12     );
      $setuphold ( posedge CKB &&& con_B,         negedge B12, TAS,     TAH,     n_flag_B12     );

      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA0, TDS,     TDH,     n_flag_DIA0    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA0, TDS,     TDH,     n_flag_DIA0    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB0, TDS,     TDH,     n_flag_DIB0    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB0, TDS,     TDH,     n_flag_DIB0    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA1, TDS,     TDH,     n_flag_DIA1    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA1, TDS,     TDH,     n_flag_DIA1    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB1, TDS,     TDH,     n_flag_DIB1    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB1, TDS,     TDH,     n_flag_DIB1    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA2, TDS,     TDH,     n_flag_DIA2    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA2, TDS,     TDH,     n_flag_DIA2    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB2, TDS,     TDH,     n_flag_DIB2    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB2, TDS,     TDH,     n_flag_DIB2    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA3, TDS,     TDH,     n_flag_DIA3    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA3, TDS,     TDH,     n_flag_DIA3    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB3, TDS,     TDH,     n_flag_DIB3    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB3, TDS,     TDH,     n_flag_DIB3    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA4, TDS,     TDH,     n_flag_DIA4    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA4, TDS,     TDH,     n_flag_DIA4    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB4, TDS,     TDH,     n_flag_DIB4    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB4, TDS,     TDH,     n_flag_DIB4    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA5, TDS,     TDH,     n_flag_DIA5    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA5, TDS,     TDH,     n_flag_DIA5    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB5, TDS,     TDH,     n_flag_DIB5    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB5, TDS,     TDH,     n_flag_DIB5    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA6, TDS,     TDH,     n_flag_DIA6    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA6, TDS,     TDH,     n_flag_DIA6    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB6, TDS,     TDH,     n_flag_DIB6    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB6, TDS,     TDH,     n_flag_DIB6    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA7, TDS,     TDH,     n_flag_DIA7    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA7, TDS,     TDH,     n_flag_DIA7    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB7, TDS,     TDH,     n_flag_DIB7    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB7, TDS,     TDH,     n_flag_DIB7    );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA8, TDS,     TDH,     n_flag_DIA8    );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA8, TDS,     TDH,     n_flag_DIA8    );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB8, TDS,     TDH,     n_flag_DIB8    );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB8, TDS,     TDH,     n_flag_DIB8    );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA9, TDS,     TDH,     n_flag_DIA9    );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA9, TDS,     TDH,     n_flag_DIA9    );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB9, TDS,     TDH,     n_flag_DIB9    );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB9, TDS,     TDH,     n_flag_DIB9    );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA10, TDS,     TDH,     n_flag_DIA10   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA10, TDS,     TDH,     n_flag_DIA10   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB10, TDS,     TDH,     n_flag_DIB10   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB10, TDS,     TDH,     n_flag_DIB10   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA11, TDS,     TDH,     n_flag_DIA11   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA11, TDS,     TDH,     n_flag_DIA11   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB11, TDS,     TDH,     n_flag_DIB11   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB11, TDS,     TDH,     n_flag_DIB11   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA12, TDS,     TDH,     n_flag_DIA12   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA12, TDS,     TDH,     n_flag_DIA12   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB12, TDS,     TDH,     n_flag_DIB12   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB12, TDS,     TDH,     n_flag_DIB12   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA13, TDS,     TDH,     n_flag_DIA13   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA13, TDS,     TDH,     n_flag_DIA13   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB13, TDS,     TDH,     n_flag_DIB13   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB13, TDS,     TDH,     n_flag_DIB13   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA14, TDS,     TDH,     n_flag_DIA14   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA14, TDS,     TDH,     n_flag_DIA14   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB14, TDS,     TDH,     n_flag_DIB14   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB14, TDS,     TDH,     n_flag_DIB14   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA15, TDS,     TDH,     n_flag_DIA15   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA15, TDS,     TDH,     n_flag_DIA15   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB15, TDS,     TDH,     n_flag_DIB15   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB15, TDS,     TDH,     n_flag_DIB15   );

      $setuphold ( posedge CKA &&& con_WEAN0,     posedge WEAN0, TWS,     TWH,     n_flag_WEAN0   );
      $setuphold ( posedge CKA &&& con_WEAN0,     negedge WEAN0, TWS,     TWH,     n_flag_WEAN0   );
      $setuphold ( posedge CKA &&& con_WEAN1,     posedge WEAN1, TWS,     TWH,     n_flag_WEAN1   );
      $setuphold ( posedge CKA &&& con_WEAN1,     negedge WEAN1, TWS,     TWH,     n_flag_WEAN1   );
      $setuphold ( posedge CKB &&& con_WEBN0,     posedge WEBN0, TWS,     TWH,     n_flag_WEBN0   );
      $setuphold ( posedge CKB &&& con_WEBN0,     negedge WEBN0, TWS,     TWH,     n_flag_WEBN0   );
      $setuphold ( posedge CKB &&& con_WEBN1,     posedge WEBN1, TWS,     TWH,     n_flag_WEBN1   );
      $setuphold ( posedge CKB &&& con_WEBN1,     negedge WEBN1, TWS,     TWH,     n_flag_WEBN1   );
      $setuphold ( posedge CKA,                   posedge CSA, TCSS,    TCSH,    n_flag_CSA     );
      $setuphold ( posedge CKA,                   negedge CSA, TCSS,    TCSH,    n_flag_CSA     );
      $setuphold ( posedge CKB,                   posedge CSB, TCSS,    TCSH,    n_flag_CSB     );
      $setuphold ( posedge CKB,                   negedge CSB, TCSS,    TCSH,    n_flag_CSB     );
      $period    ( posedge CKA &&& con_CKA,       TRC,                       n_flag_CKA_PER );
      $width     ( posedge CKA &&& con_CKA,       THPW,    0,                n_flag_CKA_MINH);
      $width     ( negedge CKA &&& con_CKA,       TLPW,    0,                n_flag_CKA_MINL);
      $period    ( posedge CKB &&& con_CKB,       TRC,                       n_flag_CKB_PER );
      $width     ( posedge CKB &&& con_CKB,       THPW,    0,                n_flag_CKB_MINH);
      $width     ( negedge CKB &&& con_CKB,       TLPW,    0,                n_flag_CKB_MINL);

      if (NODELAYA0 == 0)  (posedge CKA => (DOA0 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB0 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA1 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB1 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA2 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB2 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA3 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB3 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA4 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB4 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA5 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB5 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA6 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB6 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA7 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB7 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA8 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB8 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA9 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB9 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA10 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB10 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA11 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB11 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA12 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB12 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA13 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB13 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA14 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB14 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA15 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB15 :1'bx)) = TAA  ;


      (OEA => DOA0) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB0) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA1) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB1) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA2) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB2) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA3) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB3) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA4) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB4) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA5) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB5) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA6) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB6) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA7) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB7) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA8) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB8) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA9) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB9) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA10) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB10) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA11) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB11) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA12) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB12) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA13) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB13) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA14) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB14) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA15) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB15) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
   endspecify

`endprotect
endmodule 